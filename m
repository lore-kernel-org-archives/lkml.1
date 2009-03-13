Return-Path: <linux-kernel-owner+w=401wt.eu-S1758436AbZCMIOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436AbZCMIOg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 04:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbZCMIMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 04:12:16 -0400
Received: from gw.goop.org ([64.81.55.164]:34806 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753160AbZCMIMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 04:12:13 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 07/24] xen: remove xen_load_gdt debug
Date: Fri, 13 Mar 2009 01:11:43 -0700
Message-Id: <1236931920-6861-8-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236931920-6861-1-git-send-email-jeremy@goop.org>
References: <1236931920-6861-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Don't need the noise.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 48b399b..75b7a0f 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -310,9 +310,6 @@ static void xen_load_gdt(const struct desc_ptr *dtr)
 
 		frames[f] = mfn;
 
-		printk("xen_load_gdt: %d va=%p mfn=%lx pfn=%lx va'=%p\n",
-		       f, (void *)va, mfn, pfn, virt);
-
 		make_lowmem_page_readonly((void *)va);
 		make_lowmem_page_readonly(virt);
 	}
-- 
1.6.0.6

