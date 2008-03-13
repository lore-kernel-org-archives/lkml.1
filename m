Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbYCMR4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbYCMR4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 13:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbYCMR4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 13:56:00 -0400
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:27793 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbYCMR4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 13:56:00 -0400
Date: Thu, 13 Mar 2008 18:53:52 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       LKML <linux-kernel@vger.kernel.org>
Subject: x86: fix uml with generic find_next_bit for x86
Message-ID: <20080313175351.GA4711@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Thu, 13 Mar 2008 18:55:45 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.73; VDF: 7.0.3.26; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: fix uml with generic find_next_bit for x86

This fixes uml breakage I introduced in "change x86 to use
generic find_next_bit", which is now in x86-testing.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

---

Hello Ingo,

My patch "change x86 to use generic find_next_bit" broke
uml builds. Here is what should be added to that patch
to get it to work for uml too.

Greetings,
	Alexander

 arch/um/Kconfig.i386   |    4 ++++
 arch/um/Kconfig.x86_64 |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/um/Kconfig.i386 b/arch/um/Kconfig.i386
index 3cd8a04..164d29c 100644
--- a/arch/um/Kconfig.i386
+++ b/arch/um/Kconfig.i386
@@ -43,6 +43,10 @@ config ARCH_REUSE_HOST_VSYSCALL_AREA
 	bool
 	default y
 
+config GENERIC_FIND_NEXT_BIT
+	bool
+	default y
+
 config GENERIC_HWEIGHT
 	bool
 	default y
diff --git a/arch/um/Kconfig.x86_64 b/arch/um/Kconfig.x86_64
index 6533b34..a29f545 100644
--- a/arch/um/Kconfig.x86_64
+++ b/arch/um/Kconfig.x86_64
@@ -31,6 +31,10 @@ config SMP_BROKEN
 	bool
 	default y
 
+config GENERIC_FIND_NEXT_BIT
+	bool
+	default y
+
 config GENERIC_HWEIGHT
 	bool
 	default y

