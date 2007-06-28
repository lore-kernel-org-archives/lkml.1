Return-Path: <linux-kernel-owner+w=401wt.eu-S1765310AbXF1SKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765310AbXF1SKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 14:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762051AbXF1SKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 14:10:25 -0400
Received: from www.osadl.org ([213.239.205.134]:38532 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754946AbXF1SKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 14:10:24 -0400
From: =?iso-8859-1?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
To: "Midhun Agnihotram" <agnimidhun@gmail.com>
Subject: Re: Mounting MMC card
Date: Thu, 28 Jun 2007 20:10:16 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx
References: <4dde4acb0706261146s5906d8f3vb787d5aecb429116@mail.gmail.com> <4dde4acb0706281000p180d0066s11a21afe17336fb4@mail.gmail.com> <4dde4acb0706281008h2241f4c4nef18dc130bfe6fdd@mail.gmail.com>
In-Reply-To: <4dde4acb0706281008h2241f4c4nef18dc130bfe6fdd@mail.gmail.com>
Organization: Linutronix
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706282010.16856.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 28 Juni 2007 19:08 schrieb Midhun Agnihotram:

>     How do I access the MMC card data now? If I try to mount it,
> busybox doesnot mount it.
> 
> # mount /dev/mmcblk0p0 /mnt/mmc
> mount: mounting /dev/mmcblk0p0 on /mnt/mmc failed
> 
>   I have tried with /dev/mmcblk0p0, mmcblk0p1,etc. But of no use. How
> do I access the contents of MMC card? Is there any thing missing in my
> settings? Busybox does not say anything other than the above error
> message.

Unfortunately, busybox mount is not very verbose. You get the above
mentioned error message even if the device file doesn't exist...

You should check:

* Is the driver for your MMC actually loaded?
* Did it initialize correctly? Does it find your MMC card?
* Is support for the file system on the MMC in your kernel?
* /dev/mmcblk0p0 and /mnt/mmc really exist? (sorry, but...)

Check the output of dmesg for messages from the mmc driver.

Hans

