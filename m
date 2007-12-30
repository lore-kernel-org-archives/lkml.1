Return-Path: <linux-kernel-owner+w=401wt.eu-S1758868AbXL3Vli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868AbXL3Vli (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 16:41:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755398AbXL3Vla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 16:41:30 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:57211 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755004AbXL3Vl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 16:41:28 -0500
Date: Sun, 30 Dec 2007 22:41:27 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
Subject: [PATCH] x86: gitignore arch/x86/vdso files
Message-ID: <20071230214127.GA16421@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Teach git to ignore generated files in
arch/x86/vdso/*

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Roland McGrath <roland@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/vdso/.gitignore        |    4 ++++
 arch/x86/vdso/vdso32/.gitignore |    1 +
 2 files changed, 5 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/vdso/vdso32/.gitignore

diff --git a/arch/x86/vdso/.gitignore b/arch/x86/vdso/.gitignore
index f8b69d8..b9030e5 100644
--- a/arch/x86/vdso/.gitignore
+++ b/arch/x86/vdso/.gitignore
@@ -1 +1,5 @@
 vdso.lds
+vdso-syms.lds
+vdso32-syms.lds
+vdso32-syscall-syms.lds
+vdso32-sysenter-syms.lds
diff --git a/arch/x86/vdso/vdso32/.gitignore b/arch/x86/vdso/vdso32/.gitignore
new file mode 100644
index 0000000..e45fba9
--- /dev/null
+++ b/arch/x86/vdso/vdso32/.gitignore
@@ -0,0 +1 @@
+vdso32.lds
-- 
1.5.3.7.1112.g9758e

