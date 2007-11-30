Return-Path: <linux-kernel-owner+w=401wt.eu-S1755394AbXLFMsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbXLFMsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754577AbXLFMmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:42:53 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:53722 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbXLFMmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:42:46 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <a255c72ee61ff46372eeb97a5f8f2ecd105c642e.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Date: Fri, 30 Nov 2007 15:47:34 +0100
Subject: [PATCH 20/47] Fixup CRISv32 kernel Makefile.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Remove CRISv32 common arbiter, dma, io and pinmux files,
  they are now defined in machine dependent directories.
- Add cache and cacheflush files for working around cache problems
  in CRISv32 chips.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v32/kernel/Makefile |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/cris/arch-v32/kernel/Makefile b/arch/cris/arch-v32/kernel/Makefile
index 5d5b613..993d987 100644
--- a/arch/cris/arch-v32/kernel/Makefile
+++ b/arch/cris/arch-v32/kernel/Makefile
@@ -1,4 +1,3 @@
-# $Id: Makefile,v 1.11 2004/12/17 10:16:13 starvik Exp $
 #
 # Makefile for the linux kernel.
 #
@@ -6,9 +5,9 @@
 extra-y	:= head.o
 
 
-obj-y   := entry.o traps.o irq.o debugport.o dma.o pinmux.o \
+obj-y   := entry.o traps.o irq.o debugport.o \
 	   process.o ptrace.o setup.o signal.o traps.o time.o \
-	   arbiter.o io.o
+	   cache.o cacheflush.o
 
 obj-$(CONFIG_ETRAXFS_SIM) += vcs_hook.o
 
-- 
1.5.3.6.970.gd25430

