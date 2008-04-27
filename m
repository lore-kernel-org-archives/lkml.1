Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbYD0HKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbYD0HKk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 03:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbYD0HKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 03:10:33 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:11856 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbYD0HKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 03:10:32 -0400
Message-ID: <a24804730804270010v48a47b18i94a22e14fb8cffd0@mail.gmail.com>
Date: Sun, 27 Apr 2008 00:10:32 -0700
From: "Chris Peterson" <cpeterso@cpeterso.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] fix warning "control reaches end of non-void function" in arch/x86/kernel/vsmp_64.c
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch against linux-2.6.25-git7.

chris


Signed-off-by: Chris Peterson <cpeterso@cpeterso.com>
---
diff -Naur linux-2.6.25-git7/arch/x86/kernel/vsmp_64.c
linux-2.6.25-git7+patch/arch/x86/kernel/vsmp_64.c
--- linux-2.6.25-git7/arch/x86/kernel/vsmp_64.c	2008-04-25
22:46:17.000000000 -0700
+++ linux-2.6.25-git7+patch/arch/x86/kernel/vsmp_64.c	2008-04-25
23:32:32.000000000 -0700
@@ -133,7 +133,7 @@
 	}
 }
 #else
-static int __init detect_vsmp_box(void)
+static void __init detect_vsmp_box(void)
 {
 }
 int is_vsmp_box(void)
