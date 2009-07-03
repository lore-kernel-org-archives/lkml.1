Return-Path: <linux-kernel-owner+w=401wt.eu-S1754306AbZGCJhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbZGCJhX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 05:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbZGCJhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 05:37:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:53557 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbZGCJhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 05:37:10 -0400
Date: Fri, 3 Jul 2009 09:36:37 GMT
From: tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, jaswinder@kernel.org, gorcunov@gmail.com,
       jaswinderrajput@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, jaswinder@kernel.org, gorcunov@gmail.com,
       jaswinderrajput@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1246554239.2242.27.camel@jaswinder.satnam>
References: <1246554239.2242.27.camel@jaswinder.satnam>
Subject: [tip:x86/urgent] x86: Remove unused variable disable_x2apic
Message-ID: <tip-87489b7a2be2d04432c246379484d9e030f64658@git.kernel.org>
Git-Commit-ID: 87489b7a2be2d04432c246379484d9e030f64658
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Jul 2009 09:36:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  87489b7a2be2d04432c246379484d9e030f64658
Gitweb:     http://git.kernel.org/tip/87489b7a2be2d04432c246379484d9e030f64658
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Thu, 2 Jul 2009 22:33:59 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Jul 2009 11:34:07 +0200

x86: Remove unused variable disable_x2apic

setup_nox2apic() is writing 1 to disable_x2apic but no one is reading it.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
LKML-Reference: <1246554239.2242.27.camel@jaswinder.satnam>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/apic.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 8c7c042..0a1c283 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -140,7 +140,6 @@ int x2apic_mode;
 #ifdef CONFIG_X86_X2APIC
 /* x2apic enabled before OS handover */
 static int x2apic_preenabled;
-static int disable_x2apic;
 static __init int setup_nox2apic(char *str)
 {
 	if (x2apic_enabled()) {
@@ -149,7 +148,6 @@ static __init int setup_nox2apic(char *str)
 		return 0;
 	}
 
-	disable_x2apic = 1;
 	setup_clear_cpu_cap(X86_FEATURE_X2APIC);
 	return 0;
 }
