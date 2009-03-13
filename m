Return-Path: <linux-kernel-owner+w=401wt.eu-S1758632AbZCMIRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632AbZCMIRr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 04:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757498AbZCMIM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 04:12:27 -0400
Received: from gw.goop.org ([64.81.55.164]:34821 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755965AbZCMIMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 04:12:23 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 12/24] x86-64: remove PGE from must-have feature list
Date: Fri, 13 Mar 2009 01:11:48 -0700
Message-Id: <1236931920-6861-13-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236931920-6861-1-git-send-email-jeremy@goop.org>
References: <1236931920-6861-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

PGE may not be available when running paravirtualized, so test the cpuid
bit before using it.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/required-features.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/required-features.h b/arch/x86/include/asm/required-features.h
index d5cd6c5..a4737dd 100644
--- a/arch/x86/include/asm/required-features.h
+++ b/arch/x86/include/asm/required-features.h
@@ -50,7 +50,7 @@
 #ifdef CONFIG_X86_64
 #define NEED_PSE	0
 #define NEED_MSR	(1<<(X86_FEATURE_MSR & 31))
-#define NEED_PGE	(1<<(X86_FEATURE_PGE & 31))
+#define NEED_PGE	0
 #define NEED_FXSR	(1<<(X86_FEATURE_FXSR & 31))
 #define NEED_XMM	(1<<(X86_FEATURE_XMM & 31))
 #define NEED_XMM2	(1<<(X86_FEATURE_XMM2 & 31))
-- 
1.6.0.6

