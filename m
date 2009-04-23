Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbZDWGqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbZDWGqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 02:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbZDWGq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 02:46:29 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:46666 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbZDWGq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 02:46:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=I8VtUjmSq3brdS898YdSSwjhlmv1Ag2aeCMTPyua3EsXN/4OED2BopdDnfeVi2lFAl
         vp27wu6Yof/L6HoFwyooDg7KI2xm3Lh9zu0ydKycb2DU3ZGbeYCmDNE5jxHzpnjpTXEz
         rQWJSzuDB18pmACT0+bMQDchadZh0OaIdH04I=
Message-ID: <49F00EBB.7040504@gmail.com>
Date: Thu, 23 Apr 2009 00:46:19 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andy Isaacson <adi@hexapodia.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [2.6.30-rc2] CD-R: wodim intermittent failures: [sr0] Add.  
 Sense: Logical block address out of range, sector 0
References: <20090421015234.GA7014@hexapodia.org> <20090422144904.407df635.akpm@linux-foundation.org>
In-Reply-To: <20090422144904.407df635.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 20 Apr 2009 18:52:34 -0700
> Andy Isaacson <adi@hexapodia.org> wrote:
> 
>> I'm running 2.6.30-rc2-00446-ga939b96 on a Dell E4300 with a
>> upgraded-to-Jaunty-mostly Ubuntu install.  Using 2.6.28 and 2.6.29.1,
>> I've successfully burned a dozen CDRs, but since updating to .30-rc1
>> I've noticed intermittent failures to burn CDRs using wodim at the Gnome
>> desktop.  (Switching back to .29.1 makes wodim reliable again.)  There
>> have been a few different failure modes, but all of them seem to be
>> associated with these messages in dmesg, which I haven't seen before:
>>
>> [  360.740810] sr 1:0:0:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> [  360.740816] sr 1:0:0:0: [sr0] Sense Key : Illegal Request [current] 
>> [  360.740820] sr 1:0:0:0: [sr0] Add. Sense: Logical block address out of range
>> [  360.740826] end_request: I/O error, dev sr0, sector 0
>> [  360.740830] Buffer I/O error on device sr0, logical block 0

...

> Oh well, let's tentatively assume that we have a post-2.6.29 regression
> in the libata ahci driver.

I tend to doubt it's a problem in ahci itself, I would guess it's higher 
up the stack. Or could be that it's not a kernel bug, just some change 
in timing that triggers the problem.

What's supposed to stop udev/hal from poking at the drive while wodim is 
writing to the disc, anyway?
