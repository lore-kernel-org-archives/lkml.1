Return-Path: <linux-kernel-owner+w=401wt.eu-S1755515AbXJ1Pwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbXJ1Pwm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 11:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbXJ1Pwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 11:52:31 -0400
Received: from main.gmane.org ([80.91.229.2]:52602 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbXJ1Pwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 11:52:30 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: Check dependencies for modules "dm-snapshot" and "sd_mod" in kernel
 2.6.23.1
Date: Sun, 28 Oct 2007 16:52:06 +0100
Message-ID: <fg2b7g$1hj$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p508c416a.dip.t-dialin.net
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I get the following output from the command "make install" after the source files were
successfully compiled for my personal configuration.

if [ -r System.map -a -x /sbin/depmod ]; then /sbin/depmod -ae -F System.map
2.6.23.1-default; fi
sh /usr/src/linux-2.6.23.1/arch/i386/boot/install.sh 2.6.23.1-default
arch/x86_64/boot/bzImage System.map "/boot"

Kernel image:   /boot/vmlinuz-2.6.23.1-default
Initrd image:   /boot/initrd-2.6.23.1-default
Root device:    /dev/system/root (mounted on / as ext3)
Resume device:  /dev/sdb5
WARNING Cannot determine dependencies of kernel module 'dm-snapshot'.
        Does it exist? If it does, try depmod -a. Continuing without dm-snapshot.
WARNING Cannot determine dependencies of kernel module 'sd_mod'.
        Does it exist? If it does, try depmod -a. Continuing without sd_mod.
Kernel Modules: processor thermal libata pata_amd sata_nv sata_sil24 fan jbd mbcache ext3
dm-mod edd usbcore ohci-hcd uhci-hcd ehci-hcd hid usbhid linear
Features:       keyboard-blink dm block usb lvm2 resume.userspace resume.kernel
Bootsplash:     SuSE (1024x768)
20893 blocks

Is anything wrong here with the executable generation for these modules?
Are there any open issues with dependency management for (LVM) snapshots and SCSI devices?

Regards,
Markus

