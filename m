Return-Path: <linux-kernel-owner+w=401wt.eu-S1758966AbYFPGao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966AbYFPGao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 02:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757181AbYFPGaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 02:30:01 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50323 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753414AbYFPG3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 02:29:51 -0400
From: Paul Jackson <pj@sgi.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Jack Steiner" <steiner@sgi.com>,
       "Mike Travis" <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>
Date: Sun, 15 Jun 2008 23:29:51 -0700
Message-Id: <20080616062951.14597.96720.sendpatchset@polaris-admin.engr.sgi.com>
In-Reply-To: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
References: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
Subject: [PATCH 2/8] x86 boot: e820 code indentation fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

Fix indentation.  An earlier code merge got the
indentation of four lines of code off by a tab.

Signed-off-by: Paul Jackson <pj@sgi.com>

---
 arch/x86/kernel/e820.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux.orig/arch/x86/kernel/e820.c	2008-06-10 22:37:27.000000000 -0700
+++ linux/arch/x86/kernel/e820.c	2008-06-10 23:04:17.728936162 -0700
@@ -207,10 +207,10 @@ int __init sanitize_e820_map(struct e820
 		struct e820entry *pbios; /* pointer to original bios entry */
 		unsigned long long addr; /* address for this change point */
 	};
-static struct change_member change_point_list[2*E820_X_MAX] __initdata;
-static struct change_member *change_point[2*E820_X_MAX] __initdata;
-static struct e820entry *overlap_list[E820_X_MAX] __initdata;
-static struct e820entry new_bios[E820_X_MAX] __initdata;
+	static struct change_member change_point_list[2*E820_X_MAX] __initdata;
+	static struct change_member *change_point[2*E820_X_MAX] __initdata;
+	static struct e820entry *overlap_list[E820_X_MAX] __initdata;
+	static struct e820entry new_bios[E820_X_MAX] __initdata;
 	struct change_member *change_tmp;
 	unsigned long current_type, last_type;
 	unsigned long long last_addr;

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
