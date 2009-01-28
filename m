Return-Path: <linux-kernel-owner+w=401wt.eu-S1751356AbZA1ThU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356AbZA1ThU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 14:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbZA1ThF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 14:37:05 -0500
Received: from relay1.sgi.com ([192.48.179.29]:54248 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750899AbZA1ThE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 14:37:04 -0500
Date: Wed, 28 Jan 2009 13:36:59 -0600
From: Jack Steiner <steiner@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] - Exclude UV definitions on 32-bit x86
Message-ID: <20090128193659.GA22761@sgi.com>
References: <20090122174917.563627000@sgi.com> <20090122175025.475956000@sgi.com> <20090128013527.005648cc.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128013527.005648cc.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate compile errors on 32-bit X86 caused by UV.

Signed-off-by: Jack Steiner <steiner@sgi.com>
---

Note to Andrew:  this patch should be applied BEFORE including the recent
GRU patches.



 arch/x86/include/asm/uv/uv_hub.h |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/arch/x86/include/asm/uv/uv_hub.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_hub.h	2009-01-28 08:27:44.000000000 -0600
+++ linux/arch/x86/include/asm/uv/uv_hub.h	2009-01-28 08:32:43.000000000 -0600
@@ -11,6 +11,7 @@
 #ifndef _ASM_X86_UV_UV_HUB_H
 #define _ASM_X86_UV_UV_HUB_H
 
+#ifdef CONFIG_X86_64
 #include <linux/numa.h>
 #include <linux/percpu.h>
 #include <linux/timer.h>
@@ -413,4 +414,5 @@ static inline void uv_hub_send_ipi(int p
 }
 
 
+#endif /* CONFIG_X86_64 */
 #endif /* _ASM_X86_UV_UV_HUB_H */
