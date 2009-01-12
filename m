Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbZALPU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbZALPU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 10:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbZALPUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 10:20:50 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:44844 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbZALPUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 10:20:49 -0500
X-Greylist: delayed 331 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Jan 2009 10:19:59 EST
Date: Mon, 12 Jan 2009 16:20:44 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: "yi li" <liyi.dev@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] MMC/SD: SDHC card capacity not correct
Message-ID: <20090112162044.2bc12cef@mjolnir.drzeus.cx>
In-Reply-To: <a0e7fce50901081953h7ae152a7y557794c07fbb843b@mail.gmail.com>
References: <a0e7fce50901081953h7ae152a7y557794c07fbb843b@mail.gmail.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2009 11:53:52 +0800
"yi li" <liyi.dev@gmail.com> wrote:

> Hi Pierre,
> 
> I am using a Transcend SDHC 8GB SD card, with mmc-spi driver in
> Linux-2.6.28. When inserting the card, the messages shows the card
> capacity is "3.51 GiB":
> "mmc0: new SDHC card on SPI
> mmcblk0: mmc0:0000 SDC   3.51 GiB
>  mmcblk0: p1  "
> 
> While fdisk shows correct capacity:
> " fdisk -l /dev/mmcblk0
> Disk /dev/mmcblk0: 8068 MB, 8068268032 bytes

Odd. Is the entire device accessible? (I.e. is it just a printk
problem?)

Could you give me a dmesg dump with MMC_DEBUG turned on in Kconfig?

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
