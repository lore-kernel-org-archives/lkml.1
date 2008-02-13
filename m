Return-Path: <linux-kernel-owner+w=401wt.eu-S1764426AbYBMVbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764426AbYBMVbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbYBMV3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:29:53 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:47452 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207AbYBMV3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:29:52 -0500
Date: Wed, 13 Feb 2008 23:29:36 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Chandramouli Narayanan <mouli@linux.intel.com>,
       Huang Ying <ying.huang@intel.com>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86: make struct efi_phys static
Message-ID: <20080213212936.GF3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thuis patch makes the needlessly global struct efi_phys static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
3002c1d384e748f2928823ff4b10ed4d6082dceb 
diff --git a/arch/x86/kernel/efi.c b/arch/x86/kernel/efi.c
index 1411324..1211ab2 100644
--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -54,7 +54,7 @@ EXPORT_SYMBOL(efi);
 
 struct efi_memory_map memmap;
 
-struct efi efi_phys __initdata;
+static struct efi efi_phys __initdata;
 static efi_system_table_t efi_systab __initdata;
 
 static int __init setup_noefi(char *arg)

