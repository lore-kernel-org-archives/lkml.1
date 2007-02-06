Return-Path: <linux-kernel-owner+w=401wt.eu-S965575AbXBFXbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965575AbXBFXbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:31:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965581AbXBFXbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:31:34 -0500
Received: from mail.screens.ru ([213.234.233.54]:58479 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965575AbXBFXb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:31:26 -0500
Date: Wed, 7 Feb 2007 02:31:29 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] workqueue: make init_workqueues() __init
Message-ID: <20070206233129.GA130@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The only caller of init_workqueues() is do_basic_setup().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 6.20-rc6-mm3/kernel/workqueue.c~6_init	2007-02-07 02:02:06.000000000 +0300
+++ 6.20-rc6-mm3/kernel/workqueue.c	2007-02-07 02:15:08.000000000 +0300
@@ -820,7 +820,7 @@ static int __devinit workqueue_cpu_callb
 	return NOTIFY_OK;
 }
 
-void init_workqueues(void)
+void __init init_workqueues(void)
 {
 	cpu_populated_map = cpu_online_map;
 	singlethread_cpu = first_cpu(cpu_possible_map);

