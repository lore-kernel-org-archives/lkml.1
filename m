Return-Path: <linux-kernel-owner+w=401wt.eu-S1758891AbYE2Sve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891AbYE2Sve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755555AbYE2Sv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:51:26 -0400
Received: from smtp-01.datacomm.ch ([212.40.2.26]:51853 "EHLO
	smtp-01.datacomm.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363AbYE2SvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:51:25 -0400
Subject: Re: >3G => iommu => suspend problems -- was Re: SB600 AHCI: Hard
	Disk Corruption
From: Patrick <ragamuffin@datacomm.ch>
To: Pavel Machek <pavel@suse.cz>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1212086641.4625.56.camel@localhost.localdomain>
References: <1211717435.6038.53.camel@localhost.localdomain>
	 <20080525173825.GA4132@ucw.cz>
	 <1211746106.6188.57.camel@localhost.localdomain>
	 <20080525203921.GB18781@elf.ucw.cz> <20080525211016.GA32478@elf.ucw.cz>
	 <1211815881.6140.19.camel@localhost.localdomain>
	 <20080527112236.GA13957@elf.ucw.cz>
	 <1212086641.4625.56.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 29 May 2008 20:51:23 +0200
Message-Id: <1212087083.4625.62.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_This_ was meant to be the first footnote, actually:

*
I guess these build warnings have nothing to do with the patch I
applied:

root@babar:/mnt/reiser/linux/linux-2.6.25# make -j3 CONFIG_DEBUG_SECTION_MISMATCH=y
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  Building modules, stage 2.
Kernel: arch/x86/boot/bzImage is ready  (#2)
  MODPOST 1876 modules
WARNING: drivers/isdn/hisax/hisax.o(.text+0xbc7): Section mismatch in reference from the function HiSax_inithardware() to the function .devinit.text:hisax_cs_setup_card()
The function HiSax_inithardware() references
the function __devinit hisax_cs_setup_card().
This is often because HiSax_inithardware lacks a __devinit
annotation or the annotation of hisax_cs_setup_card is wrong.

WARNING: drivers/isdn/hisax/hisax.o(.text+0xccc): Section mismatch in reference from the function hisax_init_pcmcia() to the function .devinit.text:hisax_cs_setup_card()
The function hisax_init_pcmcia() references
the function __devinit hisax_cs_setup_card().
This is often because hisax_init_pcmcia lacks a __devinit
annotation or the annotation of hisax_cs_setup_card is wrong.

WARNING: drivers/isdn/hisax/hisax.o(.text+0x1198): Section mismatch in reference from the function hisax_register() to the function .devinit.text:hisax_cs_setup_card()
The function hisax_register() references
the function __devinit hisax_cs_setup_card().
This is often because hisax_register lacks a __devinit
annotation or the annotation of hisax_cs_setup_card is wrong.

WARNING: drivers/scsi/gdth.o(.text+0x3c35): Section mismatch in reference from the function gdth_pci_probe_one() to the function .init.text:gdth_search_drives()
The function gdth_pci_probe_one() references
the function __init gdth_search_drives().
This is often because gdth_pci_probe_one lacks a __init
annotation or the annotation of gdth_search_drives is wrong.

WARNING: drivers/scsi/gdth.o(.text+0x3d3a): Section mismatch in reference from the function gdth_pci_probe_one() to the function .init.text:gdth_enable_int()
The function gdth_pci_probe_one() references
the function __init gdth_enable_int().
This is often because gdth_pci_probe_one lacks a __init
annotation or the annotation of gdth_enable_int is wrong.



