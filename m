Return-Path: <linux-kernel-owner+w=401wt.eu-S1760213AbYGBVVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760213AbYGBVVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 17:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754652AbYGBVSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 17:18:46 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:14604 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757402AbYGBVSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 17:18:45 -0400
X-BigFish: VPS22(zzzz10d3izzz32i87il64h)
X-Spam-TCS-SCL: 3:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3EDTR-02-CTV-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 02/11] x86/pci: Makefile merge: Removing include dir flag
Date: Wed, 2 Jul 2008 22:50:20 +0200
Message-ID: <1215031829-29124-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1215031829-29124-1-git-send-email-robert.richter@amd.com>
References: <1215031829-29124-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 02 Jul 2008 21:17:55.0771 (UTC) FILETIME=[186128B0:01C8DC89]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/pci/Makefile |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
index 8d1648d..d33c57d 100644
--- a/arch/x86/pci/Makefile
+++ b/arch/x86/pci/Makefile
@@ -31,9 +31,6 @@ else
 #
 # Makefile for X86_64 specific PCI routines
 #
-# Reuse the i386 PCI subsystem
-#
-EXTRA_CFLAGS += -Iarch/x86/pci
 
 obj-y		:= i386.o
 obj-$(CONFIG_PCI_DIRECT)+= direct.o
-- 
1.5.5.4


