Return-Path: <linux-kernel-owner+w=401wt.eu-S1756924AbZEUWlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbZEUWlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 18:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754712AbZEUWlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 18:41:11 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:44902 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbZEUWlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 18:41:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=lxMtXX+FX3gS307NkAnLlhle6qgEB9t6+6PaRft4pjppRkdxS7Ly4+xsFVhi1s3Qy5
         6OHKReLZFUbEufPsdnifN6rBMwSC47P31rHh6fCe/yOrZs/g11Xa8IxIL1ZFdxeTGqwE
         YzL9ntEbd6Lq94vzBS/RcTiBvvyuH7Gxi6Y3Q=
Message-ID: <4A15D85C.3030708@gmail.com>
Date: Fri, 22 May 2009 00:40:28 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1pre) Gecko/20090521 Shredder/3.0b3pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: BUG: blank screen - unless keyboard/synaptic combo
References: <4A12FCB2.6090409@gmail.com>
In-Reply-To: <4A12FCB2.6090409@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2009 08:38 PM, Niel Lambrechts wrote:
> I have a strange problem in that during a resume from hibernate my 
> text console (or X) remains blank - that is, until I simultaneously 
> press a keyboard key and touch the synaptic pad. It is not sufficient 
> to press just one or the other, it needs to be done simultaneously and 
> it resumes fine after doing this.

I have tried quite hard to overcome this issue. All of the following 
hibernation tests I tried involved booting into a text console, without 
ever starting X. With each test I still had a blank screen upon resume, 
and each time it was fully recoverable by pressing any keyboard 
key/synaptic pad touch combo.

1. Disabling a CPU core - NO CHANGE.
Based on a "multi-processor concurrency" fix mentioned on the web 
(Ubuntu bug #272307).

2. Upgrade BIOS to latest level - NO CHANGE.
BIOS 6FET70WW, released 04/17/2009.

3. Switching to ATI Mobility Radeon HD 3650 graphics card. NO CHANGE.
My Lenovo W500 has "switchable graphics" BIOS option, and I tried this 
test with both the integrated or the above-mentioned card without 
difference.
_This result seems quite interesting to me, as if it could be some type 
of bus related freeze where the keyboard/synaptic combo plays a role._

4. Disabling BIOS Options - NO CHANGE.
Enabling/disabling security chip features + TXT features.
Disabling fingerprint reader.
Disabling memory security feature.

5. Kernel options - NO CHANGE.
ACPI debugging - I enabled CONFIG_ACPI_DEBUG, but did not see any 
messages generated when I pressed a keyboard key + synaptic mousepad 
combo that recovers the console.
FIRMWARE_EDID - still testing this.

Any suggestions on anything else I could try would be most welcome...!

Thanks,
Niel

