Return-Path: <linux-kernel-owner+w=401wt.eu-S1757959AbYD0Irl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959AbYD0Irl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 04:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbYD0Ird
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 04:47:33 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:44413 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbYD0Irb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 04:47:31 -0400
Date: Sun, 27 Apr 2008 04:47:19 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, Adrian Bunk <bunk@stusta.de>
Subject: [PATCH] Remove apparently unused fd1772.h header file.
Message-ID: <alpine.LFD.1.10.0804270442270.23791@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This header file has been unused for quite some time, and the
corresponding source files appear to have been removed back in commit
99eb8a550d.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

commit 99eb8a550dbccc0e1f6c7e866fe421810e0585f6
Author: Adrian Bunk <bunk@stusta.de>
Date:   Tue Jul 31 00:38:19 2007 -0700

    Remove the arm26 port

    The arm26 port has been in a state where it was far from even compiling
    for quite some time.

    Ian Molton agreed with the removal.

    Signed-off-by: Adrian Bunk <bunk@stusta.de>
    Cc: Ian Molton <spyro@f2s.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>



diff --git a/include/linux/fd1772.h b/include/linux/fd1772.h
deleted file mode 100644
index 871d6e4..0000000
--- a/include/linux/fd1772.h
+++ /dev/null
@@ -1,80 +0,0 @@
-#ifndef _LINUX_FD1772REG_H
-#define _LINUX_FD1772REG_H
-
-/*
-** WD1772 stuff - originally from the M68K Linux
- * Modified for Archimedes by Dave Gilbert (gilbertd@cs.man.ac.uk)
- */
-
-/* register codes */
-
-#define FDC1772SELREG_STP   (0x80)   /* command/status register */
-#define FDC1772SELREG_TRA   (0x82)   /* track register */
-#define FDC1772SELREG_SEC   (0x84)   /* sector register */
-#define FDC1772SELREG_DTA   (0x86)   /* data register */
-
-/* register names for FDC1772_READ/WRITE macros */
-
-#define FDC1772REG_CMD         0
-#define FDC1772REG_STATUS      0
-#define FDC1772REG_TRACK       2
-#define FDC1772REG_SECTOR      4
-#define FDC1772REG_DATA                6
-
-/* command opcodes */
-
-#define FDC1772CMD_RESTORE  (0x00)   /*  -                   */
-#define FDC1772CMD_SEEK     (0x10)   /*   |                  */
-#define FDC1772CMD_STEP     (0x20)   /*   |  TYP 1 Commands  */
-#define FDC1772CMD_STIN     (0x40)   /*   |                  */
-#define FDC1772CMD_STOT     (0x60)   /*  -                   */
-#define FDC1772CMD_RDSEC    (0x80)   /*  -   TYP 2 Commands  */
-#define FDC1772CMD_WRSEC    (0xa0)   /*  -          "        */
-#define FDC1772CMD_RDADR    (0xc0)   /*  -                   */
-#define FDC1772CMD_RDTRA    (0xe0)   /*   |  TYP 3 Commands  */
-#define FDC1772CMD_WRTRA    (0xf0)   /*  -                   */
-#define FDC1772CMD_FORCI    (0xd0)   /*  -   TYP 4 Command   */
-
-/* command modifier bits */
-
-#define FDC1772CMDADD_SR6   (0x00)   /* step rate settings */
-#define FDC1772CMDADD_SR12  (0x01)
-#define FDC1772CMDADD_SR2   (0x02)
-#define FDC1772CMDADD_SR3   (0x03)
-#define FDC1772CMDADD_V     (0x04)   /* verify */
-#define FDC1772CMDADD_H     (0x08)   /* wait for spin-up */
-#define FDC1772CMDADD_U     (0x10)   /* update track register */
-#define FDC1772CMDADD_M     (0x10)   /* multiple sector access */
-#define FDC1772CMDADD_E     (0x04)   /* head settling flag */
-#define FDC1772CMDADD_P     (0x02)   /* precompensation */
-#define FDC1772CMDADD_A0    (0x01)   /* DAM flag */
-
-/* status register bits */
-
-#define        FDC1772STAT_MOTORON     (0x80)   /* motor on */
-#define        FDC1772STAT_WPROT       (0x40)   /* write protected (FDC1772CMD_WR*) */
-#define        FDC1772STAT_SPINUP      (0x20)   /* motor speed stable (Type I) */
-#define        FDC1772STAT_DELDAM      (0x20)   /* sector has deleted DAM (Type II+III) */
-#define        FDC1772STAT_RECNF       (0x10)   /* record not found */
-#define        FDC1772STAT_CRC         (0x08)   /* CRC error */
-#define        FDC1772STAT_TR00        (0x04)   /* Track 00 flag (Type I) */
-#define        FDC1772STAT_LOST        (0x04)   /* Lost Data (Type II+III) */
-#define        FDC1772STAT_IDX         (0x02)   /* Index status (Type I) */
-#define        FDC1772STAT_DRQ         (0x02)   /* DRQ status (Type II+III) */
-#define        FDC1772STAT_BUSY        (0x01)   /* FDC1772 is busy */
-
-
-/* PSG Port A Bit Nr 0 .. Side Sel .. 0 -> Side 1  1 -> Side 2 */
-#define DSKSIDE     (0x01)
-
-#define DSKDRVNONE  (0x06)
-#define DSKDRV0     (0x02)
-#define DSKDRV1     (0x04)
-
-/* step rates */
-#define        FDC1772STEP_6   0x00
-#define        FDC1772STEP_12  0x01
-#define        FDC1772STEP_2   0x02
-#define        FDC1772STEP_3   0x03
-
-#endif

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
