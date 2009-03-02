Return-Path: <linux-kernel-owner+w=401wt.eu-S1758620AbZCBQ5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620AbZCBQ5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 11:57:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757909AbZCBQ53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 11:57:29 -0500
Received: from mx1.emlix.com ([193.175.82.87]:33859 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755192AbZCBQ52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 11:57:28 -0500
References: <20090302164257.477296438@emlix.com>
User-Agent: quilt/0.46-1
Date: Mon, 02 Mar 2009 17:42:58 +0100
From: Johannes Weiner <jw@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org
Subject: [patch 1/7] xtensa: kernel/traps.c: include hardirq.h
Content-Disposition: inline; filename=xtensa-traps-include-hardirqh.patch
Message-Id: <E1LeBSI-0003Yl-Oq@mailer.emlix.com>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file refers to in_interrupt() so hardirq.h must be included.

Signed-off-by: Johannes Weiner <jw@emlix.com>
---
 arch/xtensa/kernel/traps.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/xtensa/kernel/traps.c
+++ b/arch/xtensa/kernel/traps.c
@@ -25,6 +25,7 @@
 
 #include <linux/kernel.h>
 #include <linux/sched.h>
+#include <linux/hardirq.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/stringify.h>

-- 

