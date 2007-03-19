Return-Path: <linux-kernel-owner+w=401wt.eu-S933771AbXCSCsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933771AbXCSCsZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 22:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933763AbXCSCsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 22:48:21 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:21029 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933755AbXCSCsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 22:48:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ZD/Gly7o+X5bYp+RdSdr5H/itYju1KQCj32A2atptTZSvJfhWVGi1KLmrZn69OLERwTBgGAfeSVz1ibrwKJNgMrHU2yRIGAraPPcWkJse04D/DnlbOGNPX0HkRpKRGEBbEak/mlrjBQ5O7ab+Pl55/OUd6cxjqmWmHIBR1asqlU=
Message-ID: <45FDF9EE.20303@gmail.com>
Date: Mon, 19 Mar 2007 11:48:14 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Christian <christiand59@web.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BUG 2.6.21-rc3-git9] SATA NCQ failure with Samsum HD401LJ
References: <fa.wBi/iM3CKSfrll7UnPHTbU0scEQ@ifi.uio.no> <200703161544.59430.christiand59@web.de> <45FCD16D.90806@gmail.com> <200703182131.00476.christiand59@web.de>
In-Reply-To: <200703182131.00476.christiand59@web.de>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian wrote:
> On Sunday 18 March 2007 06:43:09 you wrote:
>> Christian wrote:
>>>> This does indeed look like a drive side issue to me (the controller is
>>>> reporting CPBs with response flags 2 which as far as I can tell
>>>> indicates it's still waiting for the drive to complete the request).
>>> I have been using this hw-config (SATA II, NCQ) since the nvidia ADMA
>>> support made it in the -mm kernel (maybe around 2.6.19-mm? or even
>>> earlyer). I'm seeing this problem excessively since I upgraded to
>>> 2.6.21-rc3-mm1. I think something got broken recently...
>> Can you post the result of "hdparm -I /dev/sdX"?
> 
> Output generated on 2.6.21-rc3-mm1 #3 SMP PREEMPT
> 
> user@ubuntu:~$ sudo hdparm -I /dev/sda
> 
> /dev/sda:
> 
> ATA device, with non-removable media
>         Model Number:       SAMSUNG HD401LJ
>         Serial Number:      S0HVJ1FL900207
>         Firmware Revision:  ZZ100-15
> Standards:
>         Used: ATA/ATAPI-7 T13 1532D revision 4a
>         Supported: 7 6 5 4
> Configuration:
>         Logical         max     current
>         cylinders       16383   16383
>         heads           16      16
>         sectors/track   63      63
>         --
>         CHS current addressable sectors:   16514064
>         LBA    user addressable sectors:  268435455
>         LBA48  user addressable sectors:  781422768
>         device size with M = 1024*1024:      381554 MBytes
>         device size with M = 1000*1000:      400088 MBytes (400 GB)

That's a fairly recent drive.  Does the problem go away if you downgrade
the kernel?

-- 
tejun
