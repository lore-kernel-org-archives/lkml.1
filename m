Return-Path: <linux-kernel-owner+w=401wt.eu-S1763460AbXGFJ6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763460AbXGFJ6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 05:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760525AbXGFJ6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 05:58:25 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:56080 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759416AbXGFJ6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 05:58:24 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 6 Jul 2007 05:55:23 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: dead CONFIG variables in kernel Makefiles
Message-ID: <Pine.LNX.4.64.0707060553350.10501@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	UPPERCASE_25_50 0.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  in addition to references to non-existent CONFIG variables in header
and source files, here's a list of such variables in Makefiles
throughout the entire tree:

===== BF548 =====
./arch/blackfin/Makefile:cpu-$(CONFIG_BF548) := bf548
===== BF549 =====
./arch/blackfin/Makefile:cpu-$(CONFIG_BF549) := bf549
===== BF_REV_0_0 =====
./arch/blackfin/Makefile:rev-$(CONFIG_BF_REV_0_0)  := 0.0
===== BF_REV_0_1 =====
./arch/blackfin/Makefile:rev-$(CONFIG_BF_REV_0_1)  := 0.1
===== CPU_ARM946T =====
./arch/arm/Makefile:tune-$(CONFIG_CPU_ARM946T)	:=$(call cc-option,-mtune=arm9e,-mtune=arm9tdmi)
===== CPU_FREQ_BF533 =====
./arch/blackfin/mach-bf533/Makefile:obj-$(CONFIG_CPU_FREQ_BF533) += cpu.o
===== CPU_R4000 =====
./arch/mips/kernel/Makefile:obj-$(CONFIG_CPU_R4000)		+= r4k_fpu.o r4k_switch.o
===== ETRAXFS_SIM =====
./arch/cris/arch-v32/kernel/Makefile:obj-$(CONFIG_ETRAXFS_SIM) += vcs_hook.o
===== L7200_KEYB =====
./drivers/acorn/char/Makefile:obj-$(CONFIG_L7200_KEYB)	+= defkeymap-l7200.o keyb_l7200.o
===== MACHINE =====
./arch/ppc/boot/simple/Makefile:# zimage-$(CONFIG_MACHINE) and zimagerd-$(CONFIG_MACHINE) to the target
./arch/ppc/boot/simple/Makefile:# that produces the desired image and they must set end-$(CONFIG_MACHINE)
./arch/ppc/boot/simple/Makefile:# than 'zImage.elf', set end-$(CONFIG_MACHINE) to be the suffix used for
./arch/ppc/boot/simple/Makefile:# set entrypoint-$(CONFIG_MACHINE) to the location which the image should be
./arch/ppc/boot/simple/Makefile:# loaded at.  The optimal setting for entrypoint-$(CONFIG_MACHINE) is the link
./arch/ppc/boot/simple/Makefile:# misc-$(CONFIG_MACHINE) variable.
===== NLS_ABC =====
./fs/nls/Makefile:obj-$(CONFIG_NLS_ABC)		+= nls_abc.o
===== NLS_ISO8859_10 =====
./fs/nls/Makefile:obj-$(CONFIG_NLS_ISO8859_10)	+= nls_iso8859-10.o
===== RADIO_MIROPCM20 =====
./drivers/media/radio/Makefile:obj-$(CONFIG_RADIO_MIROPCM20) += miropcm20.o
===== RADIO_MIROPCM20_RDS =====
./drivers/media/radio/Makefile:obj-$(CONFIG_RADIO_MIROPCM20_RDS) += miropcm20-rds.o
===== RXRPC =====
./net/Makefile:obj-$(CONFIG_RXRPC)		+= rxrpc/
===== SA1100_USB =====
./arch/arm/mach-sa1100/Makefile:#obj-$(CONFIG_SA1100_USB)		+= usb/
===== SCSI_FD_8xx =====
./drivers/scsi/Makefile:obj-$(CONFIG_SCSI_FD_8xx)	+= seagate.o
===== SOUND_ACI_MIXER =====
./sound/oss/Makefile:obj-$(CONFIG_SOUND_ACI_MIXER)	+= aci.o
===== SOUND_AD1816 =====
./sound/oss/Makefile:obj-$(CONFIG_SOUND_AD1816)	+= ad1816.o
===== SOUND_AD1889 =====
./sound/oss/Makefile:obj-$(CONFIG_SOUND_AD1889)	+= ad1889.o ac97_codec.o
===== SOUND_ADLIB =====
./sound/oss/Makefile:obj-$(CONFIG_SOUND_ADLIB)	+= adlib_card.o opl3.o
===== SOUND_EMU10K1 =====
./sound/oss/Makefile:obj-$(CONFIG_SOUND_EMU10K1)	+= ac97_codec.o
./sound/oss/Makefile:  obj-$(CONFIG_SOUND_EMU10K1)	+= sound.o
./sound/oss/Makefile:obj-$(CONFIG_SOUND_EMU10K1)	+= emu10k1/
./sound/oss/emu10k1/Makefile:obj-$(CONFIG_SOUND_EMU10K1) += emu10k1.o
===== SOUND_ES1371 =====
./sound/oss/Makefile:obj-$(CONFIG_SOUND_ES1371)	+= es1371.o ac97_codec.o
===== SOUND_FUSION =====
./sound/oss/Makefile:obj-$(CONFIG_SOUND_FUSION)	+= cs46xx.o ac97_codec.o
===== SOUND_NM256 =====
./sound/oss/Makefile:obj-$(CONFIG_SOUND_NM256)	+= nm256_audio.o ac97.o
===== SOUND_OPL3SA2 =====
./sound/oss/Makefile:obj-$(CONFIG_SOUND_OPL3SA2)	+= opl3sa2.o ad1848.o mpu401.o
===== SOUND_WM97XX =====
./sound/oss/Makefile:obj-$(CONFIG_SOUND_WM97XX)	+= ac97_plugin_wm97xx.o
===== TTY_LOG =====
./arch/um/os-Linux/Makefile:obj-$(CONFIG_TTY_LOG) += tty_log.o
./arch/um/os-Linux/Makefile:user-objs-$(CONFIG_TTY_LOG) += tty_log.o
===== USB_OHCI_AT91 =====
./drivers/usb/Makefile:obj-$(CONFIG_USB_OHCI_AT91)	+= host/
===== XTENSA_VARIANT_LINUX_CUSTOM =====
./arch/xtensa/Makefile:variant-$(CONFIG_XTENSA_VARIANT_LINUX_CUSTOM)	:= custom

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
