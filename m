Return-Path: <linux-kernel-owner+w=401wt.eu-S937264AbXHHTEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937264AbXHHTEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 15:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760363AbXHHTD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 15:03:56 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:47268 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674AbXHHTDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 15:03:55 -0400
Subject: [PATCH RT] Add missing semicolon in percpu_list.h
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: RT <linux-rt-users@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 08 Aug 2007 15:03:12 -0400
Message-Id: <1186599792.29097.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

This patch adds a missing semicolon in the percpu_list.h under 
!CONFIG_SMP.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6.23-rc2-rt2/include/linux/percpu_list.h
===================================================================
--- linux-2.6.23-rc2-rt2.orig/include/linux/percpu_list.h
+++ linux-2.6.23-rc2-rt2/include/linux/percpu_list.h
@@ -84,7 +84,7 @@ void percpu_list_fold(struct percpu_list
 
 struct percpu_list {
 	struct lock_list_head list;
-}
+};
 
 static inline
 void percpu_list_init(struct percpu_list *pcl)


