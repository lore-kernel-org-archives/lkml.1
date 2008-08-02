Return-Path: <linux-kernel-owner+w=401wt.eu-S1754103AbYHBNlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbYHBNlZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 09:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745AbYHBNlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 09:41:17 -0400
Received: from gustav.zipernowsky.hu ([193.225.20.248]:43382 "EHLO
	gustav.zipernowsky.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbYHBNlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 09:41:16 -0400
MIME-Version: 1.0
Date: Sat, 02 Aug 2008 15:41:10 +0200
From: Oliver Pinter <oliver@zipernowsky.hu>
To: Adrian Bunk <bunk@kernel.org>, stable@kernel.org
Subject: [RFC, 2.6.26.2-rc1] 5176/1: arm/Makefile: fix: ARM946T -> ARM946E
Reply-To: oliver.pntr@gmail.com
Message-ID: <2ff16ca447a63e5f8d062a30a60b6678@zipernowsky.hu>
User-Agent: RoundCube Webmail/0.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e6bb83fd2f39eff3ae3e5ad6cac91d154d7ef3b1 Mon Sep 17 00:00:00 2001
From: Adrian Bunk <bunk@kernel.org>
Date: Sat, 19 Jul 2008 17:52:59 +0100
Subject: [PATCH] [ARM] 5176/1: arm/Makefile: fix: ARM946T -> ARM946E

[ Upstream commit e6bb83fd2f39eff3ae3e5ad6cac91d154d7ef3b1 ]

This patch fixes a typo introduced by
commit f37f46eb1c0bd0b11c34ef06c7365658be989d80
([ARM] nommu: add ARM946E-S core support).

Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Hyok S. Choi <hyok.choi@samsung.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
CC: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index b20995a..2f07477 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -67,7 +67,7 @@ tune-$(CONFIG_CPU_ARM720T)	:=-mtune=arm7tdmi
 tune-$(CONFIG_CPU_ARM740T)	:=-mtune=arm7tdmi
 tune-$(CONFIG_CPU_ARM9TDMI)	:=-mtune=arm9tdmi
 tune-$(CONFIG_CPU_ARM940T)	:=-mtune=arm9tdmi
-tune-$(CONFIG_CPU_ARM946T)	:=$(call
cc-option,-mtune=arm9e,-mtune=arm9tdmi)
+tune-$(CONFIG_CPU_ARM946E)	:=$(call
cc-option,-mtune=arm9e,-mtune=arm9tdmi)
 tune-$(CONFIG_CPU_ARM920T)	:=-mtune=arm9tdmi
 tune-$(CONFIG_CPU_ARM922T)	:=-mtune=arm9tdmi
 tune-$(CONFIG_CPU_ARM925T)	:=-mtune=arm9tdmi


