Return-Path: <linux-kernel-owner+w=401wt.eu-S933152AbXD2LCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152AbXD2LCF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 07:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755093AbXD2LBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 07:01:30 -0400
Received: from mx1.suse.de ([195.135.220.2]:52042 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755113AbXD2Kw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:52:58 -0400
From: Andi Kleen <ak@suse.de>
References: <200704291252.514680000@suse.de>
In-Reply-To: <200704291252.514680000@suse.de>
To: Adrian Bunk <bunk@stusta.de>, Andi Kleen <ak@suse.de>,
       Zachary Amsden <zach@vmware.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [9/48] i386: make struct vmi_ops static
Message-Id: <20070429105257.368F1151C5@wotan.suse.de>
Date: Sun, 29 Apr 2007 12:52:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/vmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/i386/kernel/vmi.c
===================================================================
--- linux.orig/arch/i386/kernel/vmi.c
+++ linux/arch/i386/kernel/vmi.c
@@ -56,7 +56,7 @@ static int disable_noidle;
 static int disable_vmi_timer;
 
 /* Cached VMI operations */
-struct {
+static struct {
 	void (*cpuid)(void /* non-c */);
 	void (*_set_ldt)(u32 selector);
 	void (*set_tr)(u32 selector);
