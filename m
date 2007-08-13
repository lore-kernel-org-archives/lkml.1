Return-Path: <linux-kernel-owner+w=401wt.eu-S1758145AbXHMUDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145AbXHMUDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 16:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbXHMUCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 16:02:52 -0400
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:59170 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751606AbXHMUCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 16:02:51 -0400
Date: Mon, 13 Aug 2007 22:02:41 +0200
From: Andreas Radke <a.radke@arcor.de>
To: linux-kernel@vger.kernel.org
Subject: sata drive loosing connection/resetting port
Message-ID: <20070813220241.3f4b8df5@workstation64.home>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

running ArchLinux kernel 2.6.22.2 on a Abit IP35 Pro motherboard with
Pro Intel P35 chipset (ICH9R + Jmicron) i have these entries all few
minutes:

ata1.00: exception Emask 0x10 SAct 0x0 SErr 0x400101 action 0x2 frozen
ata1.00: (irq_stat 0x08000000, interface fatal error)
ata1.00: cmd ca/00:f8:18:d2:27/00:00:00:00:00/e6 tag 0 cdb 0x0 data
126976 out res 50/00:00:80:2b:3d/00:00:00:00:00/e0 Emask 0x10 (ATA bus
error) ata1: soft resetting port
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/133
ata1: EH complete
sd 0:0:0:0: [sda] 145226112 512-byte hardware sectors (74356 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA


hard disc is a Western Digital 10k Raptor connected to the ICH9R. on
the second port of the southbridge is another Samsung hard disc drive
connected without errors. both controllers are running ahci mode.

lsmod:
sr_mod                 16548  0 
cdrom                  38312  1 sr_mod
sd_mod                 25088  6 
pata_jmicron            5888  0 
ahci                   22404  4 
libata                119440  2 pata_jmicron,ahci

i've tried changing the SATA cables and also the power wire to the
disc without success. i checked the disc successfully with Hitachi
drive fitness test. it has worked without any trouble so far in a Intel
P965 ICH8 based mainboard.

any idea how to find the reason?

Andreas Radke
ArchLinux developer/maintainer
