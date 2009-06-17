Return-Path: <linux-kernel-owner+w=401wt.eu-S1758849AbZFQRER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849AbZFQRER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 13:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756371AbZFQREE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 13:04:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:40793 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557AbZFQREC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 13:04:02 -0400
Date: Wed, 17 Jun 2009 17:03:34 GMT
From: tip-bot for Huang Weiyi <weiyi.huang@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu, weiyi.huang@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, weiyi.huang@gmail.com, mingo@elte.hu
In-Reply-To: <1244895686-2348-1-git-send-email-weiyi.huang@gmail.com>
References: <1244895686-2348-1-git-send-email-weiyi.huang@gmail.com>
Subject: [tip:x86/urgent] x86: Remove duplicated #include's
Message-ID: <tip-8653f88ff93ba6bd6df4bac48908d41ad09dba7e@git.kernel.org>
Git-Commit-ID: 8653f88ff93ba6bd6df4bac48908d41ad09dba7e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 17:03:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8653f88ff93ba6bd6df4bac48908d41ad09dba7e
Gitweb:     http://git.kernel.org/tip/8653f88ff93ba6bd6df4bac48908d41ad09dba7e
Author:     Huang Weiyi <weiyi.huang@gmail.com>
AuthorDate: Sat, 13 Jun 2009 20:21:26 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 17 Jun 2009 19:02:35 +0200

x86: Remove duplicated #include's

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
LKML-Reference: <1244895686-2348-1-git-send-email-weiyi.huang@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/probe_32.c  |   11 -----------
 arch/x86/kernel/apic/summit_32.c |    1 -
 2 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index 440a8bc..0c0182c 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -20,23 +20,12 @@
 #include <asm/apic.h>
 #include <asm/setup.h>
 
-#include <linux/threads.h>
-#include <linux/cpumask.h>
-#include <asm/mpspec.h>
-#include <asm/fixmap.h>
-#include <asm/apicdef.h>
-#include <linux/kernel.h>
-#include <linux/string.h>
 #include <linux/smp.h>
-#include <linux/init.h>
 #include <asm/ipi.h>
 
-#include <linux/smp.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <asm/acpi.h>
 #include <asm/e820.h>
-#include <asm/setup.h>
 
 #ifdef CONFIG_HOTPLUG_CPU
 #define DEFAULT_SEND_IPI	(1)
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index 344eee4..eafdfbd 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -44,7 +44,6 @@
 #include <asm/ipi.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
-#include <linux/init.h>
 #include <linux/gfp.h>
 #include <linux/smp.h>
 
