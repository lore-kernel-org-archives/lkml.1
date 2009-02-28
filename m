Return-Path: <linux-kernel-owner+w=401wt.eu-S1763863AbZB1CI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763863AbZB1CI2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 21:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761299AbZB1B7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:59:46 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:59204
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757479AbZB1B7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:59:34 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH] xen mtrr: Kill some unneccessary includes
Date: Fri, 27 Feb 2009 17:59:22 -0800
Message-Id: <1235786365-17744-17-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1235786365-17744-1-git-send-email-jeremy@goop.org>
References: <1235786365-17744-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark McLoughlin <markmc@redhat.com>

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 arch/x86/kernel/cpu/mtrr/mtrr.h |    2 ++
 arch/x86/kernel/cpu/mtrr/xen.c  |    8 +-------
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.h b/arch/x86/kernel/cpu/mtrr/mtrr.h
index eb23ca2..6142d6e 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.h
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.h
@@ -5,6 +5,8 @@
 #include <linux/types.h>
 #include <linux/stddef.h>
 
+#include <asm/mtrr.h>
+
 #define MTRRcap_MSR     0x0fe
 #define MTRRdefType_MSR 0x2ff
 
diff --git a/arch/x86/kernel/cpu/mtrr/xen.c b/arch/x86/kernel/cpu/mtrr/xen.c
index e03532c..7a25f88 100644
--- a/arch/x86/kernel/cpu/mtrr/xen.c
+++ b/arch/x86/kernel/cpu/mtrr/xen.c
@@ -1,12 +1,6 @@
 #include <linux/init.h>
-#include <linux/proc_fs.h>
-#include <linux/ctype.h>
-#include <linux/module.h>
-#include <linux/seq_file.h>
-#include <asm/uaccess.h>
-#include <linux/mutex.h>
-
-#include <asm/mtrr.h>
+#include <linux/mm.h>
+
 #include "mtrr.h"
 
 #include <xen/interface/platform.h>
-- 
1.6.0.6

