Return-Path: <linux-kernel-owner+w=401wt.eu-S1760177AbZDLKk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760177AbZDLKk2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 06:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759253AbZDLKkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 06:40:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:45128 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755673AbZDLKkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 06:40:16 -0400
Date: Sun, 12 Apr 2009 10:39:35 GMT
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jaswinder@kernel.org, jaswinderrajput@gmail.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinder@kernel.org, jaswinderrajput@gmail.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1239434726.4418.24.camel@localhost.localdomain>
References: <1239434726.4418.24.camel@localhost.localdomain>
Subject: [tip:x86/cleanups] x86: apic/x2apic_cluster.c x86_cpu_to_logical_apicid should be static
Message-ID: <tip-0be88dbc90fceb2261a8358b796d203475235da9@git.kernel.org>
Git-Commit-ID: 0be88dbc90fceb2261a8358b796d203475235da9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 12 Apr 2009 10:39:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0be88dbc90fceb2261a8358b796d203475235da9
Gitweb:     http://git.kernel.org/tip/0be88dbc90fceb2261a8358b796d203475235da9
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Sat, 11 Apr 2009 12:55:26 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 12 Apr 2009 12:38:01 +0200

x86: apic/x2apic_cluster.c x86_cpu_to_logical_apicid should be static

Impact: reduce kernel size a bit, address sparse warning

Fixes sparse warning:
  arch/x86/kernel/apic/x2apic_cluster.c:13:1: warning: symbol 'per_cpu__x86_cpu_to_logical_apicid' was not declared. Should it be static?

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <1239434726.4418.24.camel@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/x2apic_cluster.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 4a903e2..8e4cbb2 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -10,7 +10,7 @@
 #include <asm/apic.h>
 #include <asm/ipi.h>
 
-DEFINE_PER_CPU(u32, x86_cpu_to_logical_apicid);
+static DEFINE_PER_CPU(u32, x86_cpu_to_logical_apicid);
 
 static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
