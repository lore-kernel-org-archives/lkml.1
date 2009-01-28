Return-Path: <linux-kernel-owner+w=401wt.eu-S1762625AbZA2ATs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762625AbZA2ATs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758129AbZA1Xqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:46:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:53314 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755507AbZA1Xqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:46:44 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 089/114] x86/Voyager: remove KGDB Kconfig quirk
Date: Wed, 28 Jan 2009 23:42:35 +0000
Message-Id: <1233186180-29883-90-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:46:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86/Voyager has this KGDB quirk:

	select HAVE_ARCH_KGDB if !X86_VOYAGER

This is completely pointless - there's nothing in KGDB that cannot work
on Voyager. Remove it.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a783fe7..12b433a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -35,7 +35,7 @@ config X86
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_KVM
-	select HAVE_ARCH_KGDB if !X86_VOYAGER
+	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_GENERIC_DMA_COHERENT if X86_32
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
-- 
1.6.0.2

