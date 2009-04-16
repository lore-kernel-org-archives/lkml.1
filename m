Return-Path: <linux-kernel-owner+w=401wt.eu-S1756951AbZDPKFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951AbZDPKFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 06:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753403AbZDPKEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 06:04:46 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:57954 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752464AbZDPKEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 06:04:46 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: microblaze-uclinux@itee.uq.edu.au, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 07/11] microblaze: Add missing declaration for die and _exception func
Date: Thu, 16 Apr 2009 11:56:34 +0200
Message-Id: <f87119e246276eb41047985c97b74a5b79adc259.1239874968.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <157375351273eacf9b552e677447505542f90521.1239874968.git.monstr@monstr.eu>
References: <1239875798-10523-1-git-send-email-monstr@monstr.eu>
 <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>
 <11ed83a6ecbedc74fc543dad9cb81157ce5771ee.1239874968.git.monstr@monstr.eu>
 <f62690af2276b3fb111af2adae91e65ba1587c11.1239874968.git.monstr@monstr.eu>
 <708dba6c793117ed9ee1036cae48ed9288d328b8.1239874968.git.monstr@monstr.eu>
 <1f1874e0192d8481356551ffbeeebcecce951afc.1239874968.git.monstr@monstr.eu>
 <157375351273eacf9b552e677447505542f90521.1239874968.git.monstr@monstr.eu>
In-Reply-To: <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>
References: <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

This change remove sparse errors.

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/exceptions.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/microblaze/include/asm/exceptions.h b/arch/microblaze/include/asm/exceptions.h
index 4cdd215..24ca540 100644
--- a/arch/microblaze/include/asm/exceptions.h
+++ b/arch/microblaze/include/asm/exceptions.h
@@ -61,6 +61,9 @@
 asmlinkage void full_exception(struct pt_regs *regs, unsigned int type,
 							int fsr, int addr);
 
+void die(const char *str, struct pt_regs *fp, long err);
+void _exception(int signr, struct pt_regs *regs, int code, unsigned long addr);
+
 #if defined(CONFIG_XMON)
 extern void xmon(struct pt_regs *regs);
 extern int xmon_bpt(struct pt_regs *regs);
-- 
1.5.5.1

