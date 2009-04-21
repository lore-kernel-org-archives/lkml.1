Return-Path: <linux-kernel-owner+w=401wt.eu-S1756489AbZDUSXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489AbZDUSXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 14:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbZDUSX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 14:23:29 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:35107 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbZDUSX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 14:23:29 -0400
Subject: [PATCH][RT] - Mismatching declaration and export
From: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 21 Apr 2009 11:23:25 -0700
Message-Id: <1240338205.13601.17.camel@quadrophenia.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: Make function declaration match EXPORT()

Signed-off-by: Sven-Thorsten Dietrich <sdietrich@suse.de>

Index: b/kernel/spinlock.c
===================================================================
--- a/kernel/spinlock.c
+++ b/kernel/spinlock.c
@@ -354,7 +354,7 @@ void __lockfunc _spin_lock_nest_lock(spi
 }
 EXPORT_SYMBOL(_spin_lock_nest_lock);
 
-unsigned long __lockfunc _spin_lock_irqsave_nested(spinlock_t *lock, int subclass)
+unsigned long __lockfunc __spin_lock_irqsave_nested(spinlock_t *lock, int subclass)
 {
 	unsigned long flags;
 


