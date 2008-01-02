Return-Path: <linux-kernel-owner+w=401wt.eu-S1759831AbYABXav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759831AbYABXav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 18:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760150AbYABX0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 18:26:42 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:23172 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760135AbYABX0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 18:26:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=DKcUXoqqjflJPsoFd2AZp8E/TYIjaBjTsTv4qK9VmYZrYDFyx/pY2ZgJMQXj/Hgdv7nzur6et0mYvrZvJH6Bn6Fq76dAw5AGQxEXOvfs71EF+jGHezPKg2fCFMqPVgoKbbjk0IIRMgq2VboL4ruG8xyGL31LCnGqpN4ROButpqY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: delete filenames/versions from comments
Date: Thu, 3 Jan 2008 00:37:12 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801030037.12225.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Delete filenames/versions from comments.

I'm leaving decisions about adding DRV_VERSION defines and MODULE_VERSION()-s
to maintainers of the respective drivers.

While at it:

* Remove unused VERSION define from ide.c.

* Remove unused/stale DRV_VERSION define from au1xxx-ide.c.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
a replacement patch for "ide: delete filenames from comments" one

 drivers/ide/arm/bast-ide.c     |    3 +--
 drivers/ide/arm/icside.c       |    2 --
 drivers/ide/arm/rapide.c       |    2 --
 drivers/ide/cris/ide-cris.c    |    3 +--
 drivers/ide/h8300/ide-h8300.c  |    1 -
 drivers/ide/ide-acpi.c         |    1 -
 drivers/ide/ide-cd.h           |    2 --
 drivers/ide/ide-disk.c         |    2 --
 drivers/ide/ide-dma.c          |    3 +--
 drivers/ide/ide-floppy.c       |    2 --
 drivers/ide/ide-iops.c         |    2 --
 drivers/ide/ide-pnp.c          |    2 --
 drivers/ide/ide-probe.c        |    2 --
 drivers/ide/ide-proc.c         |    2 --
 drivers/ide/ide-tape.c         |    2 --
 drivers/ide/ide-taskfile.c     |    2 --
 drivers/ide/ide-timing.h       |    2 --
 drivers/ide/ide.c              |    3 ---
 drivers/ide/legacy/ali14xx.c   |    2 --
 drivers/ide/legacy/buddha.c    |    2 +-
 drivers/ide/legacy/dtc2278.c   |    2 --
 drivers/ide/legacy/falconide.c |    2 +-
 drivers/ide/legacy/gayle.c     |    2 +-
 drivers/ide/legacy/ht6560b.c   |    2 --
 drivers/ide/legacy/ide-cs.c    |    2 --
 drivers/ide/legacy/macide.c    |    2 +-
 drivers/ide/legacy/q40ide.c    |    2 +-
 drivers/ide/legacy/qd65xx.c    |    2 --
 drivers/ide/legacy/qd65xx.h    |    2 --
 drivers/ide/legacy/umc8672.c   |    2 --
 drivers/ide/mips/au1xxx-ide.c  |    3 ---
 drivers/ide/pci/aec62xx.c      |    2 --
 drivers/ide/pci/alim15x3.c     |    2 --
 drivers/ide/pci/amd74xx.c      |    2 --
 drivers/ide/pci/atiixp.c       |    2 --
 drivers/ide/pci/cmd640.c       |    2 --
 drivers/ide/pci/cmd64x.c       |    2 --
 drivers/ide/pci/cs5530.c       |    2 --
 drivers/ide/pci/cs5535.c       |    2 --
 drivers/ide/pci/cy82c693.c     |    2 --
 drivers/ide/pci/delkin_cb.c    |    2 --
 drivers/ide/pci/generic.c      |    2 --
 drivers/ide/pci/hpt34x.c       |    3 +--
 drivers/ide/pci/hpt366.c       |    2 --
 drivers/ide/pci/it821x.c       |    3 ---
 drivers/ide/pci/ns87415.c      |    2 --
 drivers/ide/pci/opti621.c      |    2 --
 drivers/ide/pci/pdc202xx_old.c |    2 --
 drivers/ide/pci/piix.c         |    2 --
 drivers/ide/pci/rz1000.c       |    2 --
 drivers/ide/pci/sc1200.c       |    2 --
 drivers/ide/pci/serverworks.c  |    2 --
 drivers/ide/pci/siimage.c      |    2 --
 drivers/ide/pci/sis5513.c      |    2 --
 drivers/ide/pci/sl82c105.c     |    2 --
 drivers/ide/pci/slc90e66.c     |    2 --
 drivers/ide/pci/tc86c001.c     |    2 --
 drivers/ide/pci/triflex.c      |    2 --
 drivers/ide/pci/trm290.c       |    3 +--
 drivers/ide/pci/via82cxxx.c    |    3 ---
 drivers/ide/ppc/mpc8xx.c       |    2 --
 drivers/ide/ppc/pmac.c         |    3 +--
 drivers/ide/setup-pci.c        |    4 +---
 drivers/scsi/ide-scsi.c        |    2 --
 64 files changed, 12 insertions(+), 126 deletions(-)

Index: b/drivers/ide/arm/bast-ide.c
===================================================================
--- a/drivers/ide/arm/bast-ide.c
+++ b/drivers/ide/arm/bast-ide.c
@@ -1,5 +1,4 @@
-/* linux/drivers/ide/arm/bast-ide.c
- *
+/*
  * Copyright (c) 2003-2004 Simtec Electronics
  *  Ben Dooks <ben@simtec.co.uk>
  *
Index: b/drivers/ide/arm/icside.c
===================================================================
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -1,6 +1,4 @@
 /*
- * linux/drivers/ide/arm/icside.c
- *
  * Copyright (c) 1996-2004 Russell King.
  *
  * Please note that this platform does not support 32-bit IDE IO.
Index: b/drivers/ide/arm/rapide.c
===================================================================
--- a/drivers/ide/arm/rapide.c
+++ b/drivers/ide/arm/rapide.c
@@ -1,6 +1,4 @@
 /*
- * linux/drivers/ide/arm/rapide.c
- *
  * Copyright (c) 1996-2002 Russell King.
  */
 
Index: b/drivers/ide/cris/ide-cris.c
===================================================================
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -1,5 +1,4 @@
-/* $Id: cris-ide-driver.patch,v 1.1 2005/06/29 21:39:07 akpm Exp $
- *
+/*
  * Etrax specific IDE functions, like init and PIO-mode setting etc.
  * Almost the entire ide.c is used for the rest of the Etrax ATA driver.
  * Copyright (c) 2000-2005 Axis Communications AB
Index: b/drivers/ide/h8300/ide-h8300.c
===================================================================
--- a/drivers/ide/h8300/ide-h8300.c
+++ b/drivers/ide/h8300/ide-h8300.c
@@ -1,5 +1,4 @@
 /*
- * drivers/ide/h8300/ide-h8300.c
  * H8/300 generic IDE interface
  */
 
Index: b/drivers/ide/ide-acpi.c
===================================================================
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -1,5 +1,4 @@
 /*
- * ide-acpi.c
  * Provides ACPI support for IDE drives.
  *
  * Copyright (C) 2005 Intel Corp.
Index: b/drivers/ide/ide-cd.h
===================================================================
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/ide/ide_cd.h
- *
  *  Copyright (C) 1996-98  Erik Andersen
  *  Copyright (C) 1998-2000 Jens Axboe
  */
Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/ide/ide-disk.c	Version 1.18	Mar 05, 2003
- *
  *  Copyright (C) 1994-1998  Linus Torvalds & authors (see below)
  *  Copyright (C) 1998-2002  Linux ATA Development
  *				Andre Hedrick <andre@linux-ide.org>
Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -1,7 +1,6 @@
 /*
- *  linux/drivers/ide/ide-dma.c		Version 4.10	June 9, 2000
- *
  *  Copyright (c) 1999-2000	Andre Hedrick <andre@linux-ide.org>
+ *
  *  May be copied or modified under the terms of the GNU General Public License
  */
 
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -1,6 +1,4 @@
 /*
- * linux/drivers/ide/ide-floppy.c	Version 0.99	Feb 24 2002
- *
  * Copyright (C) 1996 - 1999 Gadi Oxman <gadio@netvision.net.il>
  * Copyright (C) 2000 - 2002 Paul Bristow <paul@paulbristow.net>
  */
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -1,6 +1,4 @@
 /*
- * linux/drivers/ide/ide-iops.c	Version 0.37	Mar 05, 2003
- *
  *  Copyright (C) 2000-2002	Andre Hedrick <andre@linux-ide.org>
  *  Copyright (C) 2003		Red Hat <alan@redhat.com>
  *
Index: b/drivers/ide/ide-pnp.c
===================================================================
--- a/drivers/ide/ide-pnp.c
+++ b/drivers/ide/ide-pnp.c
@@ -1,6 +1,4 @@
 /*
- * linux/drivers/ide/ide-pnp.c
- *
  * This file provides autodetection for ISA PnP IDE interfaces.
  * It was tested with "ESS ES1868 Plug and Play AudioDrive" IDE interface.
  *
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/ide/ide-probe.c	Version 1.11	Mar 05, 2003
- *
  *  Copyright (C) 1994-1998  Linus Torvalds & authors (see below)
  */
 
Index: b/drivers/ide/ide-proc.c
===================================================================
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/ide/ide-proc.c	Version 1.05	Mar 05, 2003
- *
  *  Copyright (C) 1997-1998	Mark Lord
  *  Copyright (C) 2003		Red Hat <alan@redhat.com>
  *
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1,6 +1,4 @@
 /*
- * linux/drivers/ide/ide-tape.c		Version 1.19	Nov, 2003
- *
  * Copyright (C) 1995 - 1999 Gadi Oxman <gadio@netvision.net.il>
  *
  * $Header$
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -1,6 +1,4 @@
 /*
- * linux/drivers/ide/ide-taskfile.c	Version 0.38	March 05, 2003
- *
  *  Copyright (C) 2000-2002	Michael Cornwell <cornwell@acm.org>
  *  Copyright (C) 2000-2002	Andre Hedrick <andre@linux-ide.org>
  *  Copyright (C) 2001-2002	Klaus Smolin
Index: b/drivers/ide/ide-timing.h
===================================================================
--- a/drivers/ide/ide-timing.h
+++ b/drivers/ide/ide-timing.h
@@ -2,8 +2,6 @@
 #define _IDE_TIMING_H
 
 /*
- * $Id: ide-timing.h,v 1.6 2001/12/23 22:47:56 vojtech Exp $
- *
  *  Copyright (c) 1999-2001 Vojtech Pavlik
  */
 
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/ide/ide.c		Version 7.00beta2	Mar 05 2003
- *
  *  Copyright (C) 1994-1998  Linus Torvalds & authors (see below)
  */
 
@@ -46,7 +44,6 @@
  */
 
 #define	REVISION	"Revision: 7.00alpha2"
-#define	VERSION		"Id: ide.c 7.00a2 20020906"
 
 #define _IDE_C			/* Tell ide.h it's really us */
 
Index: b/drivers/ide/legacy/ali14xx.c
===================================================================
--- a/drivers/ide/legacy/ali14xx.c
+++ b/drivers/ide/legacy/ali14xx.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/ide/legacy/ali14xx.c		Version 0.03	Feb 09, 1996
- *
  *  Copyright (C) 1996  Linus Torvalds & author (see below)
  */
 
Index: b/drivers/ide/legacy/buddha.c
===================================================================
--- a/drivers/ide/legacy/buddha.c
+++ b/drivers/ide/legacy/buddha.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/legacy/buddha.c -- Amiga Buddha, Catweasel and X-Surf IDE Driver
+ *  Amiga Buddha, Catweasel and X-Surf IDE Driver
  *
  *	Copyright (C) 1997, 2001 by Geert Uytterhoeven and others
  *
Index: b/drivers/ide/legacy/dtc2278.c
===================================================================
--- a/drivers/ide/legacy/dtc2278.c
+++ b/drivers/ide/legacy/dtc2278.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/ide/legacy/dtc2278.c		Version 0.02	Feb 10, 1996
- *
  *  Copyright (C) 1996  Linus Torvalds & author (see below)
  */
 
Index: b/drivers/ide/legacy/falconide.c
===================================================================
--- a/drivers/ide/legacy/falconide.c
+++ b/drivers/ide/legacy/falconide.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/legacy/falconide.c -- Atari Falcon IDE Driver
+ *  Atari Falcon IDE Driver
  *
  *     Created 12 Jul 1997 by Geert Uytterhoeven
  *
Index: b/drivers/ide/legacy/gayle.c
===================================================================
--- a/drivers/ide/legacy/gayle.c
+++ b/drivers/ide/legacy/gayle.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/legacy/gayle.c -- Amiga Gayle IDE Driver
+ *  Amiga Gayle IDE Driver
  *
  *     Created 9 Jul 1997 by Geert Uytterhoeven
  *
Index: b/drivers/ide/legacy/ht6560b.c
===================================================================
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/ide/legacy/ht6560b.c		Version 0.07	Feb  1, 2000
- *
  *  Copyright (C) 1995-2000  Linus Torvalds & author (see below)
  */
 
Index: b/drivers/ide/legacy/ide-cs.c
===================================================================
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -2,8 +2,6 @@
 
     A driver for PCMCIA IDE/ATA disk cards
 
-    ide-cs.c 1.3 2002/10/26 05:45:31
-
     The contents of this file are subject to the Mozilla Public
     License Version 1.1 (the "License"); you may not use this file
     except in compliance with the License. You may obtain a copy of
Index: b/drivers/ide/legacy/macide.c
===================================================================
--- a/drivers/ide/legacy/macide.c
+++ b/drivers/ide/legacy/macide.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/legacy/macide.c -- Macintosh IDE Driver
+ *  Macintosh IDE Driver
  *
  *     Copyright (C) 1998 by Michael Schmitz
  *
Index: b/drivers/ide/legacy/q40ide.c
===================================================================
--- a/drivers/ide/legacy/q40ide.c
+++ b/drivers/ide/legacy/q40ide.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/legacy/q40ide.c -- Q40 I/O port IDE Driver
+ *  Q40 I/O port IDE Driver
  *
  *     (c) Richard Zidlicky
  *
Index: b/drivers/ide/legacy/qd65xx.c
===================================================================
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/ide/legacy/qd65xx.c		Version 0.07	Sep 30, 2001
- *
  *  Copyright (C) 1996-2001  Linus Torvalds & author (see below)
  */
 
Index: b/drivers/ide/legacy/qd65xx.h
===================================================================
--- a/drivers/ide/legacy/qd65xx.h
+++ b/drivers/ide/legacy/qd65xx.h
@@ -1,6 +1,4 @@
 /*
- * linux/drivers/ide/legacy/qd65xx.h
- *
  * Copyright (c) 2000	Linus Torvalds & authors
  */
 
Index: b/drivers/ide/legacy/umc8672.c
===================================================================
--- a/drivers/ide/legacy/umc8672.c
+++ b/drivers/ide/legacy/umc8672.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/ide/legacy/umc8672.c		Version 0.05	Jul 31, 1996
- *
  *  Copyright (C) 1995-1996  Linus Torvalds & author (see below)
  */
 
Index: b/drivers/ide/mips/au1xxx-ide.c
===================================================================
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -1,6 +1,4 @@
 /*
- * linux/drivers/ide/mips/au1xxx-ide.c  version 01.30.00        Aug. 02 2005
- *
  * BRIEF MODULE DESCRIPTION
  * AMD Alchemy Au1xxx IDE interface routines over the Static Bus
  *
@@ -50,7 +48,6 @@
 #include <asm/mach-au1x00/au1xxx_ide.h>
 
 #define DRV_NAME	"au1200-ide"
-#define DRV_VERSION	"1.0"
 #define DRV_AUTHOR	"Enrico Walther <enrico.walther@amd.com> / Pete Popov <ppopov@embeddedalley.com>"
 
 /* enable the burstmode in the dbdma */
Index: b/drivers/ide/pci/aec62xx.c
===================================================================
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -1,6 +1,4 @@
 /*
- * linux/drivers/ide/pci/aec62xx.c		Version 0.27	Sep 16, 2007
- *
  * Copyright (C) 1999-2002	Andre Hedrick <andre@linux-ide.org>
  * Copyright (C) 2007		MontaVista Software, Inc. <source@mvista.com>
  *
Index: b/drivers/ide/pci/alim15x3.c
===================================================================
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -1,6 +1,4 @@
 /*
- * linux/drivers/ide/pci/alim15x3.c		Version 0.29	Sep 16 2007
- *
  *  Copyright (C) 1998-2000 Michel Aubry, Maintainer
  *  Copyright (C) 1998-2000 Andrzej Krzysztofowicz, Maintainer
  *  Copyright (C) 1999-2000 CJ, cjtsai@ali.com.tw, Maintainer
Index: b/drivers/ide/pci/amd74xx.c
===================================================================
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -1,6 +1,4 @@
 /*
- * Version 2.25
- *
  * AMD 755/756/766/8111 and nVidia nForce/2/2s/3/3s/CK804/MCP04
  * IDE driver for Linux.
  *
Index: b/drivers/ide/pci/atiixp.c
===================================================================
--- a/drivers/ide/pci/atiixp.c
+++ b/drivers/ide/pci/atiixp.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/ide/pci/atiixp.c	Version 0.05	Nov 9 2007
- *
  *  Copyright (C) 2003 ATI Inc. <hyu@ati.com>
  *  Copyright (C) 2004,2007 Bartlomiej Zolnierkiewicz
  */
Index: b/drivers/ide/pci/cmd640.c
===================================================================
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/ide/pci/cmd640.c		Version 1.02  Sep 01, 1996
- *
  *  Copyright (C) 1995-1996  Linus Torvalds & authors (see below)
  */
 
Index: b/drivers/ide/pci/cmd64x.c
===================================================================
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -1,6 +1,4 @@
 /*
- * linux/drivers/ide/pci/cmd64x.c		Version 1.53	Dec 24, 2007
- *
  * cmd64x.c: Enable interrupts at initialization time on Ultra/PCI machines.
  *           Due to massive hardware bugs, UltraDMA is only supported
  *           on the 646U2 and not on the 646U.
Index: b/drivers/ide/pci/cs5530.c
===================================================================
--- a/drivers/ide/pci/cs5530.c
+++ b/drivers/ide/pci/cs5530.c
@@ -1,6 +1,4 @@
 /*
- * linux/drivers/ide/pci/cs5530.c		Version 0.77	Sep 24 2007
- *
  * Copyright (C) 2000			Andre Hedrick <andre@linux-ide.org>
  * Copyright (C) 2000			Mark Lord <mlord@pobox.com>
  * Copyright (C) 2007			Bartlomiej Zolnierkiewicz
Index: b/drivers/ide/pci/cs5535.c
===================================================================
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -1,6 +1,4 @@
 /*
- * linux/drivers/ide/pci/cs5535.c
- *
  * Copyright (C) 2004-2005 Advanced Micro Devices, Inc.
  * Copyright (C)      2007 Bartlomiej Zolnierkiewicz
  *
Index: b/drivers/ide/pci/cy82c693.c
===================================================================
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -1,6 +1,4 @@
 /*
- * linux/drivers/ide/pci/cy82c693.c		Version 0.44	Nov 8, 2007
- *
  *  Copyright (C) 1998-2000 Andreas S. Krebs (akrebs@altavista.net), Maintainer
  *  Copyright (C) 1998-2002 Andre Hedrick <andre@linux-ide.org>, Integrator
  *
Index: b/drivers/ide/pci/delkin_cb.c
===================================================================
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/ide/pci/delkin_cb.c
- *
  *  Created 20 Oct 2004 by Mark Lord
  *
  *  Basic support for Delkin/ASKA/Workbit Cardbus CompactFlash adapter
Index: b/drivers/ide/pci/generic.c
===================================================================
--- a/drivers/ide/pci/generic.c
+++ b/drivers/ide/pci/generic.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/ide/pci/generic.c	Version 0.11	December 30, 2002
- *
  *  Copyright (C) 2001-2002	Andre Hedrick <andre@linux-ide.org>
  *  Portions (C) Copyright 2002  Red Hat Inc <alan@redhat.com>
  *
Index: b/drivers/ide/pci/hpt34x.c
===================================================================
--- a/drivers/ide/pci/hpt34x.c
+++ b/drivers/ide/pci/hpt34x.c
@@ -1,7 +1,6 @@
 /*
- * linux/drivers/ide/pci/hpt34x.c		Version 0.40	Sept 10, 2002
- *
  * Copyright (C) 1998-2000	Andre Hedrick <andre@linux-ide.org>
+ *
  * May be copied or modified under the terms of the GNU General Public License
  *
  *
Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1,6 +1,4 @@
 /*
- * linux/drivers/ide/pci/hpt366.c		Version 1.30	Dec 12, 2007
- *
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
  * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
  * Portions Copyright (C) 2003		Red Hat Inc
Index: b/drivers/ide/pci/it821x.c
===================================================================
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -1,7 +1,4 @@
-
 /*
- * linux/drivers/ide/pci/it821x.c		Version 0.16	Jul 3 2007
- *
  * Copyright (C) 2004		Red Hat <alan@redhat.com>
  * Copyright (C) 2007		Bartlomiej Zolnierkiewicz
  *
Index: b/drivers/ide/pci/ns87415.c
===================================================================
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -1,6 +1,4 @@
 /*
- * linux/drivers/ide/pci/ns87415.c		Version 2.00  Sep. 10, 2002
- *
  * Copyright (C) 1997-1998	Mark Lord <mlord@pobox.com>
  * Copyright (C) 1998		Eddie C. Dost <ecd@skynet.be>
  * Copyright (C) 1999-2000	Andre Hedrick <andre@linux-ide.org>
Index: b/drivers/ide/pci/opti621.c
===================================================================
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/ide/pci/opti621.c		Version 0.9	Sep 24, 2007
- *
  *  Copyright (C) 1996-1998  Linus Torvalds & authors (see below)
  */
 
Index: b/drivers/ide/pci/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/ide/pci/pdc202xx_old.c	Version 0.52	Aug 27, 2007
- *
  *  Copyright (C) 1998-2002		Andre Hedrick <andre@linux-ide.org>
  *  Copyright (C) 2006-2007		MontaVista Software, Inc.
  *  Copyright (C) 2007			Bartlomiej Zolnierkiewicz
Index: b/drivers/ide/pci/piix.c
===================================================================
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/ide/pci/piix.c	Version 0.54	Sep 5, 2007
- *
  *  Copyright (C) 1998-1999 Andrzej Krzysztofowicz, Author and Maintainer
  *  Copyright (C) 1998-2000 Andre Hedrick <andre@linux-ide.org>
  *  Copyright (C) 2003 Red Hat Inc <alan@redhat.com>
Index: b/drivers/ide/pci/rz1000.c
===================================================================
--- a/drivers/ide/pci/rz1000.c
+++ b/drivers/ide/pci/rz1000.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/ide/pci/rz1000.c	Version 0.06	January 12, 2003
- *
  *  Copyright (C) 1995-1998  Linus Torvalds & author (see below)
  */
 
Index: b/drivers/ide/pci/sc1200.c
===================================================================
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -1,6 +1,4 @@
 /*
- * linux/drivers/ide/pci/sc1200.c		Version 0.97	Aug 3 2007
- *
  * Copyright (C) 2000-2002		Mark Lord <mlord@pobox.com>
  * Copyright (C)      2007		Bartlomiej Zolnierkiewicz
  *
Index: b/drivers/ide/pci/serverworks.c
===================================================================
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -1,6 +1,4 @@
 /*
- * linux/drivers/ide/pci/serverworks.c		Version 0.22	Jun 27 2007
- *
  * Copyright (C) 1998-2000 Michel Aubry
  * Copyright (C) 1998-2000 Andrzej Krzysztofowicz
  * Copyright (C) 1998-2000 Andre Hedrick <andre@linux-ide.org>
Index: b/drivers/ide/pci/siimage.c
===================================================================
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -1,6 +1,4 @@
 /*
- * linux/drivers/ide/pci/siimage.c		Version 1.19	Nov 16 2007
- *
  * Copyright (C) 2001-2002	Andre Hedrick <andre@linux-ide.org>
  * Copyright (C) 2003		Red Hat <alan@redhat.com>
  * Copyright (C) 2007		MontaVista Software, Inc.
Index: b/drivers/ide/pci/sis5513.c
===================================================================
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -1,6 +1,4 @@
 /*
- * linux/drivers/ide/pci/sis5513.c	Version 0.31	Aug 9, 2007
- *
  * Copyright (C) 1999-2000	Andre Hedrick <andre@linux-ide.org>
  * Copyright (C) 2002		Lionel Bouton <Lionel.Bouton@inet6.fr>, Maintainer
  * Copyright (C) 2003		Vojtech Pavlik <vojtech@suse.cz>
Index: b/drivers/ide/pci/sl82c105.c
===================================================================
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -1,6 +1,4 @@
 /*
- * linux/drivers/ide/pci/sl82c105.c
- *
  * SL82C105/Winbond 553 IDE driver
  *
  * Maintainer unknown.
Index: b/drivers/ide/pci/slc90e66.c
===================================================================
--- a/drivers/ide/pci/slc90e66.c
+++ b/drivers/ide/pci/slc90e66.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/ide/pci/slc90e66.c	Version 0.19	Sep 24, 2007
- *
  *  Copyright (C) 2000-2002 Andre Hedrick <andre@linux-ide.org>
  *  Copyright (C) 2006-2007 MontaVista Software, Inc. <source@mvista.com>
  *
Index: b/drivers/ide/pci/tc86c001.c
===================================================================
--- a/drivers/ide/pci/tc86c001.c
+++ b/drivers/ide/pci/tc86c001.c
@@ -1,6 +1,4 @@
 /*
- * drivers/ide/pci/tc86c001.c	Version 1.01	Sep 5, 2007
- *
  * Copyright (C) 2002 Toshiba Corporation
  * Copyright (C) 2005-2006 MontaVista Software, Inc. <source@mvista.com>
  *
Index: b/drivers/ide/pci/triflex.c
===================================================================
--- a/drivers/ide/pci/triflex.c
+++ b/drivers/ide/pci/triflex.c
@@ -1,6 +1,4 @@
 /*
- * triflex.c
- * 
  * IDE Chipset driver for the Compaq TriFlex IDE controller.
  * 
  * Known to work with the Compaq Workstation 5x00 series.
Index: b/drivers/ide/pci/trm290.c
===================================================================
--- a/drivers/ide/pci/trm290.c
+++ b/drivers/ide/pci/trm290.c
@@ -1,8 +1,7 @@
 /*
- *  linux/drivers/ide/pci/trm290.c		Version 1.05	Dec. 30, 2007
- *
  *  Copyright (c) 1997-1998  Mark Lord
  *  Copyright (c) 2007       MontaVista Software, Inc. <source@mvista.com>
+ *
  *  May be copied or modified under the terms of the GNU General Public License
  *
  *  June 22, 2004 - get rid of check_region
Index: b/drivers/ide/pci/via82cxxx.c
===================================================================
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -1,7 +1,4 @@
 /*
- *
- * Version 3.50
- *
  * VIA IDE driver for Linux. Supported southbridges:
  *
  *   vt82c576, vt82c586, vt82c586a, vt82c586b, vt82c596a, vt82c596b,
Index: b/drivers/ide/ppc/mpc8xx.c
===================================================================
--- a/drivers/ide/ppc/mpc8xx.c
+++ b/drivers/ide/ppc/mpc8xx.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/ide/ppc/ide-m8xx.c
- *
  *  Copyright (C) 2000, 2001 Wolfgang Denk, wd@denx.de
  *  Modified for direct IDE interface
  *	by Thomas Lange, thomas@corelatus.com
Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -1,7 +1,6 @@
 /*
- * linux/drivers/ide/ppc/pmac.c
- *
  * Support for IDE interfaces on PowerMacs.
+ *
  * These IDE interfaces are memory-mapped and have a DBDMA channel
  * for doing DMA.
  *
Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -1,9 +1,7 @@
 /*
- *  linux/drivers/ide/setup-pci.c		Version 1.10	2002/08/19
- *
  *  Copyright (c) 1998-2000  Andre Hedrick <andre@linux-ide.org>
- *
  *  Copyright (c) 1995-1998  Mark Lord
+ *
  *  May be copied or modified under the terms of the GNU General Public License
  */
 
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -1,6 +1,4 @@
 /*
- * linux/drivers/scsi/ide-scsi.c	Version 0.9		Jul   4, 1999
- *
  * Copyright (C) 1996 - 1999 Gadi Oxman <gadio@netvision.net.il>
  */
 
