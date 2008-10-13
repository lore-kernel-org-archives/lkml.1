Return-Path: <linux-kernel-owner+w=401wt.eu-S1760286AbYJMMOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760286AbYJMMOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 08:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756029AbYJMMOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 08:14:00 -0400
Received: from japan.chezphil.org ([77.240.5.4]:1587 "EHLO japan.chezphil.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755991AbYJMMOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 08:14:00 -0400
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Date: Mon, 13 Oct 2008 13:13:57 +0100
Subject: [PATCH] Mention Intel Atom in Kconfig.cpu (less garbled this time)
Message-ID: <1223900037856@dmwebmail.dmwebmail.chezphil.org>
In-Reply-To: <1223895506638@dmwebmail.dmwebmail.chezphil.org>
References: <1223895506638@dmwebmail.dmwebmail.chezphil.org>
X-Mailer: Decimail Webmail 3alpha16
MIME-Version: 1.0
Content-Type: text/plain; format="fixed"
From: "Phil Endecott" <phil_wueww_endecott@chezphil.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Appoligies for the garbled first attempt at posting this.  Blame the
original author for the long lines!?]

Am I right in thinking that CONFIG_MCORE2 is the correct choice for an 
Intel Atom?  (It seems to work for me, so far.)  If this is true, since 
there are quite a lot of these chips in circulation now and the choice 
is not obvious, I think it would be helpful to add something along the 
following lines to arch/x86/Kconfig.cpu.

Signed-off-by: Phil Endecott <kconfigcpu@chezphil.org>
---
diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index b225219..7df0801 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -263,11 +263,12 @@ config MPSC
           in /proc/cpuinfo. Family 15 is an older Xeon, Family 6 a newer one.

  config MCORE2
-       bool "Core 2/newer Xeon"
+       bool "Core 2/newer Xeon/Atom"
         help
-         Select this for Intel Core 2 and newer Core 2 Xeons (Xeon 51xx and 53xx)
-         CPUs. You can distinguish newer from older Xeons by the CPU family
-         in /proc/cpuinfo. Newer ones have 6 and older ones 15 (not a typo)
+         Select this for Intel Core 2, newer Core 2 Xeon (Xeon 51xx and 53xx)
+         and Intel Atom CPUs. You can distinguish newer from older Xeons by
+         the CPU family in /proc/cpuinfo. Newer ones have 6 and older ones 15
+         (not a typo).

  config GENERIC_CPU
         bool "Generic-x86-64"





