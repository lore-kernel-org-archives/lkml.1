Return-Path: <linux-kernel-owner+w=401wt.eu-S1757362AbXGIShj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362AbXGIShj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 14:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbXGIShc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 14:37:32 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:54153 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbXGIShb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 14:37:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=f93aHy+yC8h63LR8zf6MDFifUSGmq2UtL+/d2smb2cA6mRfpvwqj3D8kTFCmdfP/24Bu58kE1CsAtzqBmTxI6S/fFqNzZ1qqE/xRsiJ6d+tD92uGRWVzFi3q0OAunLzLZ5UUJcMSJCw0IrmOBI2jZJd0WZnrBc4nRAu7A2LT3s0=
Message-ID: <46928066.7000705@gmail.com>
Date: Tue, 10 Jul 2007 03:37:26 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: caglar@pardus.org.tr
CC: Robert Hancock <hancockr@shaw.ca>, LKML <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: SATA exceptions
References: <fa.hBFih6KVHDFsBf6Qfg6XispiIuY@ifi.uio.no> <fa.NhBdOmH9+RkW+QO72+TjPRwEKj0@ifi.uio.no> <468FD5ED.5060401@shaw.ca> <200707080035.05718.caglar@pardus.org.tr>
In-Reply-To: <200707080035.05718.caglar@pardus.org.tr>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

S.Çağlar Onur wrote:
> 07 Tem 2007 Cts tarihinde, Robert Hancock şunları yazmıştı: 
>> It's not the free space on the drive that matters, it's the number of
>> free sectors in the spare sector pool on the drive, which is invisible
>> to software.
>>
>> Your SMART log shows 309 reallocated sectors. That seems somewhat high..
> 
> Ah sorry to misinterpret the content:), its a quiet new piece of hardware (at 
> most ~1.5 month old) and  "Reallocated_Event_Count" constantly increases 
> (currently its increased to 313) and although i'm not 100 percent sure these 
> errors only occured with kernels > 2.6.18 (or 2.6.18 didn't report these 
> cause according to kern.log these only visible with 2.6.22+) 

OS and driver can't really do much about the reallocation event.  Some
number of reallocations is okay but if you it going up constantly, you
probably have a dying disk.

> We bought 3 HP Pavillon dv2385ea and one of them only runs with 2.6.18 and its 
> smartctl output follows as a reference;
>
>   5 Reallocated_Sector_Ct   0x0033   253   253   010    Pre-fail  
> 196 Reallocated_Event_Count 0x0032   253   253   000    Old_age   

Hmm... This is pretty high too.  Do the counts increase on this machine too?

-- 
tejun
