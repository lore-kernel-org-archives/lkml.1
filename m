Return-Path: <linux-kernel-owner+w=401wt.eu-S1763964AbYD1FHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763964AbYD1FHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 01:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbYD1FHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 01:07:09 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:63633 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbYD1FHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 01:07:08 -0400
Message-ID: <a24804730804272207q4c70975dgab2ae301a510c810@mail.gmail.com>
Date: Sun, 27 Apr 2008 22:07:07 -0700
From: "Chris Peterson" <cpeterso@cpeterso.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix warning "control reaches end of non-void function" in arch/x86/kernel/vsmp_64.c
In-Reply-To: <a24804730804270010v48a47b18i94a22e14fb8cffd0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a24804730804270010v48a47b18i94a22e14fb8cffd0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hopefully this patch will be correctly formatted..?

chris


---
diff -Naur linux-2.6.25-git7/arch/x86/kernel/vsmp_64.c
linux-2.6.25-git7+patch/arch/x86/kernel/vsmp_64.c
--- linux-2.6.25-git7/arch/x86/kernel/vsmp_64.c 2008-04-25
22:46:17.000000000 -0700
+++ linux-2.6.25-git7+patch/arch/x86/kernel/vsmp_64.c   2008-04-25
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
