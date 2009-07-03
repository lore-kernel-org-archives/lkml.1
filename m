Return-Path: <linux-kernel-owner+w=401wt.eu-S1757786AbZGCNVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786AbZGCNVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 09:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbZGCNVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 09:21:12 -0400
Received: from mail-bw0-f207.google.com ([209.85.218.207]:52608 "EHLO
	mail-bw0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbZGCNVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 09:21:11 -0400
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Jul 2009 09:21:11 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:content-type
         :content-transfer-encoding:message-id;
        b=PSdK3jVHaUQ222lexBpDYyT+Fuy563OzOWWzkA/wB3rkzORKDlwVg777m+S3MDdK8D
         gyPSxDYrTQPyidizFnkE401hQvttCkcJMCy/Jqf6KGjbtBfciKgcv/EgZlEdu2u+ZTk8
         zH05aw1YXfMpqCPr7nCiS580MZ8Rb9BHoanzo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Andrew Lyon <andrew.lyon@gmail.com>
Subject: Re: Errors in OSS Sound Blaster driver / DMA Documentation (KERN_WARN)
Date: Fri, 3 Jul 2009 15:20:27 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc1-next-20090703-03460-gb01c1b8; KDE/4.2.4; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <f4527be0907030454q290fe99t73161a0fd6c1d4d2@mail.gmail.com>
In-Reply-To: <f4527be0907030454q290fe99t73161a0fd6c1d4d2@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907031520.27883.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 July 2009 13:54:25 Andrew Lyon wrote:
> Hi,
> 
> While investigating a compile failure of Xen kernel I noticed that the
> OSS Sound Blaster driver and DMA Documentation have the same problem,
> KERN_WARNING Is valid and declared in include/linux/kernel.h,
> KERN_WARN does not exist, here are the affected files:
> 
> Documentation/DMA-mapping.txt:          printk(KERN_WARN "%s: Playback
> disabled due to DMA limitations.\n",
> Documentation/DMA-mapping.txt:          printk(KERN_WARN "%s: Record
> disabled due to DMA limitations.\n",
> arch/x86/kernel/cpu/common-xen.c:               printk(KERN_WARN
> "Unable to register CSTAR callback\n");
> sound/oss/sb_common.c:                          /* printk(KERN_WARN
> "Sound Blaster: Unexpected interrupt\n"); */
> sound/oss/sb_common.c:                          /* printk(KERN_WARN
> "Sound Blaster: Unexpected interrupt\n"); */
> sound/oss/sb_ess.c:                     /* printk(KERN_WARN "ESS:
> Unexpected interrupt\n"); */

Good spotting.  Care to send fixes for DMA-mapping / xen / sb?

Thanks.
Bart
