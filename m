Return-Path: <linux-kernel-owner+w=401wt.eu-S934134AbYEUAuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934134AbYEUAuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764290AbYEUAsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:48:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41618 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933983AbYEUAsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:48:43 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 4/6][uml] uml: add missing exports for UML_RANDOM=m
Cc: jdike@addtoit.com, linux-kernel@vger.kernel.org
Message-Id: <E1JycVW-00066R-KL@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 21 May 2008 01:48:42 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Content-Length: 581
Lines: 24

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/kernel/ksyms.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/um/kernel/ksyms.c b/arch/um/kernel/ksyms.c
index 66e2a30..ccc02a6 100644
--- a/arch/um/kernel/ksyms.c
+++ b/arch/um/kernel/ksyms.c
@@ -60,6 +60,11 @@ EXPORT_SYMBOL(os_rcv_fd);
 EXPORT_SYMBOL(run_helper);
 EXPORT_SYMBOL(start_thread);
 
+EXPORT_SYMBOL(add_sigio_fd);
+EXPORT_SYMBOL(ignore_sigio_fd);
+EXPORT_SYMBOL(deactivate_fd);
+EXPORT_SYMBOL(sigio_broken);
+
 #ifdef CONFIG_SMP
 
 /* required for SMP */
-- 
1.5.3.GIT


