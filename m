Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbXJ1QCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbXJ1QCS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 12:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750841AbXJ1QCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 12:02:04 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:54996 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbXJ1QCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 12:02:01 -0400
Date: Sun, 28 Oct 2007 17:02:00 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Markus Elfring <Markus.Elfring@web.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: Check dependencies for modules "dm-snapshot" and "sd_mod" in
 kernel 2.6.23.1
In-Reply-To: <fg2b7g$1hj$1@ger.gmane.org>
Message-ID: <Pine.LNX.4.64.0710281700360.30465@fbirervta.pbzchgretzou.qr>
References: <fg2b7g$1hj$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 28 2007 16:52, Markus Elfring wrote:
>Hello,
>
>I get the following output from the command "make install" after the source
>files were successfully compiled for my personal configuration.
>
>if [ -r System.map -a -x /sbin/depmod ]; then /sbin/depmod -ae -F System.map
>2.6.23.1-default; fi
>sh /usr/src/linux-2.6.23.1/arch/i386/boot/install.sh 2.6.23.1-default
>arch/x86_64/boot/bzImage System.map "/boot"
>
>Kernel image:   /boot/vmlinuz-2.6.23.1-default
>Initrd image:   /boot/initrd-2.6.23.1-default
>Root device:    /dev/system/root (mounted on / as ext3)
>Resume device:  /dev/sdb5
>WARNING Cannot determine dependencies of kernel module 'dm-snapshot'.
>        Does it exist? If it does, try depmod -a. Continuing without dm-snapshot.
>WARNING Cannot determine dependencies of kernel module 'sd_mod'.
>        Does it exist? If it does, try depmod -a. Continuing without sd_mod.
>Kernel Modules: processor thermal libata pata_amd sata_nv sata_sil24 fan jbd mbcache ext3
>dm-mod edd usbcore ohci-hcd uhci-hcd ehci-hcd hid usbhid linear
>Features:       keyboard-blink dm block usb lvm2 resume.userspace resume.kernel
>Bootsplash:     SuSE (1024x768)
>20893 blocks
>
>Is anything wrong here with the executable generation for these modules?
>Are there any open issues with dependency management for (LVM) snapshots and SCSI devices?


Perhaps your personal configuration is missing the
modules SUSE 10.3 requires. I'd use one of their rpms anyway.
