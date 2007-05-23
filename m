Return-Path: <linux-kernel-owner+w=401wt.eu-S1760892AbXEWBkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760892AbXEWBkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 21:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757805AbXEWBj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 21:39:56 -0400
Received: from rwcrmhc15.comcast.net ([204.127.192.85]:46662 "EHLO
	rwcrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757432AbXEWBjz (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 21:39:55 -0400
Subject: [PATCH 2.6.21-rt6]
From: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
To: LKML <Linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: The Big Corporation
Date: Tue, 22 May 2007 18:39:53 -0700
Message-Id: <1179884393.25500.86.camel@sx.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch properly exports __spin_lock_irqsave_nested.

signed-off-by: Sven-Thorsten Dietrich <sven@thebigcorporation.com>


Index: linux-2.6.21/kernel/spinlock.c
===================================================================
--- linux-2.6.21.orig/kernel/spinlock.c
+++ linux-2.6.21/kernel/spinlock.c
@@ -366,7 +366,7 @@ __spin_lock_irqsave_nested(raw_spinlock_
 #endif
 	return flags;
 }
-EXPORT_SYMBOL(_spin_lock_irqsave_nested);
+EXPORT_SYMBOL(__spin_lock_irqsave_nested);
 
 #endif
 



