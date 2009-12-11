Return-Path: <linux-kernel-owner+w=401wt.eu-S935048AbZLKXjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935048AbZLKXjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:39:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934189AbZLKXi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:38:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:57352 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935041AbZLKXh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:37:29 -0500
Message-ID: <4B22D754.2020706@kernel.org>
Date: Fri, 11 Dec 2009 15:35:48 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [PATCH 7/7] x86: increase MAX_EARLY_RES
References: <4B22D4DA.2000104@kernel.org>
In-Reply-To: <4B22D4DA.2000104@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



32bit numa run out of it, because recent change with wakeup and mptable.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/e820.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -724,7 +724,7 @@ core_initcall(e820_mark_nvs_memory);
 /*
  * Early reserved memory areas.
  */
-#define MAX_EARLY_RES 20
+#define MAX_EARLY_RES 32
 
 struct early_res {
 	u64 start, end;

