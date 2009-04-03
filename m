Return-Path: <linux-kernel-owner+w=401wt.eu-S934423AbZDCQqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934423AbZDCQqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765639AbZDCQqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 12:46:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:44373 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932636AbZDCQqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 12:46:10 -0400
Date: Fri, 3 Apr 2009 16:45:29 GMT
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090403040625.GA9473@linux.vnet.ibm.com>
References: <20090403040625.GA9473@linux.vnet.ibm.com>
Subject: [tip:core/rcu] RCU: make treercu be default
Message-ID: <tip-31c9a24ec82926fcae49483e53566d231e705057@git.kernel.org>
Git-Commit-ID: 31c9a24ec82926fcae49483e53566d231e705057
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Apr 2009 16:45:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  31c9a24ec82926fcae49483e53566d231e705057
Gitweb:     http://git.kernel.org/tip/31c9a24ec82926fcae49483e53566d231e705057
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Thu, 2 Apr 2009 21:06:25 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Apr 2009 18:27:37 +0200

RCU: make treercu be default

Impact: switch default config from CLASSIC_RCU to TREE_RCU

Given that I have not gotten any complaints or bug reports on treercu
recently, this patch makes it be the default.  There are a number of
other defconfig files that explicitly call out CLASSIC_RCU, but which
have comment headers saying not to edit them.  Probably holdovers from
one of the flavors of "make config", but...

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org
Cc: dipankar@in.ibm.com
Cc: niv@us.ibm.com
Cc: manfred@colorfullife.com
Cc: peterz@infradead.org
LKML-Reference: <20090403040625.GA9473@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 init/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 14c483d..26ac877 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -302,7 +302,7 @@ menu "RCU Subsystem"
 
 choice
 	prompt "RCU Implementation"
-	default CLASSIC_RCU
+	default TREE_RCU
 
 config CLASSIC_RCU
 	bool "Classic RCU"
