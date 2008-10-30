Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbYJ3Odv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbYJ3Odv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 10:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754823AbYJ3Odl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 10:33:41 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:20179 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbYJ3Odk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 10:33:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=V4NQBH3yQhfrj/DUa3cCwyEojvXa29N/7BWzlijoq4I5yf8gzTU31wYo9MslbmTgJT
         MfHeQ9wgKhq/H8qQU48RGBUHOyNDOgQ4pOH858LUAug1atf48J46cWDRlYY7Vwm47wAn
         xAqXhw74wpAsDw+hUdv7ay+frRhAZZ5uNOfU0=
Message-ID: <9ea470500810300733u34dab7d2rd69a8d806b85ac65@mail.gmail.com>
Date: Thu, 30 Oct 2008 15:33:38 +0100
From: "Borislav Petkov" <petkovbb@googlemail.com>
Reply-To: petkovbb@gmail.com
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.28-rc2 lost IDE disk on old laptop
Cc: "IDE/ATA development list" <linux-ide@vger.kernel.org>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
In-Reply-To: <20081030135017.GA8325@erig.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.2.00.0810261221350.3386@nehalem.linux-foundation.org>
	 <20081030135017.GA8325@erig.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Oct 30, 2008 at 2:50 PM, Wolfgang Erig <Wolfgang.Erig@gmx.de> wrote:
> Hi,
>
> the kernel 2.6.28-rc2 does not boot on my old laptop.
> Panic ... cannot access (301) ... aka /dev/hda1
> The previously used version 2.6.27-rc8 runs fine.
>
> During 'make oldconfig' I saw questions about IDE (or ATA)
> but I see no obvious problem with my .config
>
> Wolfgang
>
>
> $ lspci
> 00:00.0 Host bridge: Intel Corporation 430TX - 82439TX MTXC (rev 01)
> 00:01.0 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 01)
> 00:01.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01)

Have you tried compiling your kernel with CONFIG_BLK_DEV_PIIX enabled and
CONFIG_IDE_GENERIC disabled?

> 00:01.2 USB Controller: Intel Corporation 82371AB/EB/MB PIIX4 USB (rev 01)
> 00:01.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 01)
> 00:06.0 VGA compatible controller: Chips and Technologies F65554 (rev c2)
> 00:14.0 CardBus bridge: Cirrus Logic PD 6832 PCMCIA/CardBus Ctrlr (rev c1)
> 00:14.1 CardBus bridge: Cirrus Logic PD 6832 PCMCIA/CardBus Ctrlr (rev c1)
>
> $ egrep -i 'ide|ata' .config
> # CONFIG_X86_MCE_NONFATAL is not set
> # CONFIG_ATALK is not set
> CONFIG_HAVE_IDE=y
> CONFIG_IDE=y
> # Please see Documentation/ide/ide.txt for help/info on IDE drives
> # CONFIG_BLK_DEV_IDE_SATA is not set
> CONFIG_IDE_GD=y
> CONFIG_IDE_GD_ATA=y
> # CONFIG_IDE_GD_ATAPI is not set
> # CONFIG_BLK_DEV_IDECS is not set
> CONFIG_BLK_DEV_IDECD=y
> CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
> # CONFIG_BLK_DEV_IDETAPE is not set
> # CONFIG_BLK_DEV_IDESCSI is not set
> # CONFIG_IDE_TASK_IOCTL is not set
> # CONFIG_IDE_PROC_FS is not set
> # IDE chipset support/bugfixes
> CONFIG_IDE_GENERIC=y
> # CONFIG_BLK_DEV_IDEPNP is not set
> # PCI IDE chipsets support
> # Other IDE chipsets support
> # CONFIG_BLK_DEV_IDEDMA is not set
> # CONFIG_ATA is not set
> # CONFIG_VIDEO_DEV is not set
> # CONFIG_VIDEO_MEDIA is not set
> CONFIG_VIDEO_OUTPUT_CONTROL=m
> # CONFIG_USB_STORAGE_DATAFAB is not set
> # CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
> # CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
> # Authenticated Encryption with Associated Data
>

-- 
Regards/Gruss,
Boris
