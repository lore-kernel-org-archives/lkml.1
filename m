Return-Path: <linux-kernel-owner+w=401wt.eu-S1764844AbZEAUBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764844AbZEAUBV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 16:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755927AbZEAUBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 16:01:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:47474 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbZEAUBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 16:01:10 -0400
Date: Fri, 1 May 2009 20:00:31 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090501195425.GB4633@lenovo>
References: <20090501195425.GB4633@lenovo>
Subject: [tip:x86/apic] x86, apic: use pr_ macro
Message-ID: <tip-6f0aced639d346e5f54eea9fcb2784b633493d09@git.kernel.org>
Git-Commit-ID: 6f0aced639d346e5f54eea9fcb2784b633493d09
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 01 May 2009 20:00:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6f0aced639d346e5f54eea9fcb2784b633493d09
Gitweb:     http://git.kernel.org/tip/6f0aced639d346e5f54eea9fcb2784b633493d09
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Fri, 1 May 2009 23:54:25 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 1 May 2009 21:56:25 +0200

x86, apic: use pr_ macro

Replace recenly appeared printk with pr_ macro
(the file already use a lot of them).

[ Impact: cleanup ]

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
LKML-Reference: <20090501195425.GB4633@lenovo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/apic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 28f747d..e258bed 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2191,7 +2191,7 @@ static int __cpuinit set_multi(const struct dmi_system_id *d)
 {
 	if (multi)
 		return 0;
-	printk(KERN_INFO "APIC: %s detected, Multi Chassis\n", d->ident);
+	pr_info("APIC: %s detected, Multi Chassis\n", d->ident);
 	multi = 1;
 	return 0;
 }
