Return-Path: <linux-kernel-owner+w=401wt.eu-S1753041AbXDIHtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbXDIHtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 03:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbXDIHtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 03:49:09 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:37919 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbXDIHtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 03:49:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=OfAatNJBduHLgFTMXQ2dZb8wjbHOggeAK3kUuDLiumGzHk+wlqbEFLAWsYL82UuxtQ9+Xk8ay3GkhSidR8iRH+vBAsWXng+Pi34QkF7yxsUt6g5ZxH0NRya/jDF/FU8lLtdnWedx5u8gbyBYEU4k/d42VPWJ/g4xdjgxcMD8EwQ=
Message-ID: <4619EFEA.9030003@gmail.com>
Date: Mon, 09 Apr 2007 16:48:58 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: Kernel 2.6.20.4: Software RAID 5: ata13.00: (irq_stat 0x00020002,
 failed to transmit command FIS)
References: <Pine.LNX.4.64.0704051243080.3810@p34.internal.lan> <Pine.LNX.4.64.0704051339470.3810@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0704051339470.3810@p34.internal.lan>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> 
> 
> On Thu, 5 Apr 2007, Justin Piszcz wrote:
> 
>> Had a quick question, this is the first time I have seen this happen,
>> and it was not even under during heavy I/O, hardly anything was going
>> on with the box at the time.
> 
> .. snip ..
> 
> # /usr/bin/time badblocks -b 512 -s -v -w /dev/sdl
> Checking for bad blocks in read-write mode
> From block 0 to 293046768
> Testing with pattern 0xaa: done
> Reading and comparing: done
> 
> Not a single bad block on the drive so far.  I have not changed anything
> the box physically, with the exception of the BIOS version to V1666 for
> an Intel P965 motherboard (DG965WHMKR).  Any idea what or why this
> happened?  Is it a kernel or actual HW issue?  What caused this to
> occur?  Any thoughts or ideas?

My bet is on harddisk firmware acting weird.  You can prove this by
reconnecting the disk to known working port without cutting power.  Or,
you can prove that the original port works by removing the harddisk and
putting a different one.  You'll need to issue manual scan using SCSI
sysfs node.  It's very rare but some drives do choke like that.

-- 
tejun
