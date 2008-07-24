Return-Path: <linux-kernel-owner+w=401wt.eu-S1756972AbYGXX5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972AbYGXX5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 19:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbYGXX5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 19:57:22 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:63629 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbYGXX5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 19:57:22 -0400
Date: Thu, 24 Jul 2008 16:56:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: dipankar@in.ibm.com, akpm <akpm@linux-foundation.org>
Subject: [PATCH] rcu: fix synchronize_rcu() so that kernel-doc works
Message-Id: <20080724165602.efdd8a96.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix RCU's synchronize_cpu() so that it looks like a C function, enabling
it to be recognized as a function with kernel-doc annotation.

Warning(linux-2.6.26-git11//kernel/rcupdate.c:81): No description found for parameter 'synchronize_rcu'
Warning(linux-2.6.26-git11//kernel/rcupdate.c:81): No description found for parameter 'call_rcu'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 kernel/rcupdate.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.26-git11.orig/kernel/rcupdate.c
+++ linux-2.6.26-git11/kernel/rcupdate.c
@@ -77,6 +77,7 @@ void wakeme_after_rcu(struct rcu_head  *
  * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
  * and may be nested.
  */
+void synchronize_rcu(void);
 synchronize_rcu_xxx(synchronize_rcu, call_rcu)
 EXPORT_SYMBOL_GPL(synchronize_rcu);
 
