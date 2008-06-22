Return-Path: <linux-kernel-owner+w=401wt.eu-S1753308AbYFVOWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbYFVOWt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 10:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756261AbYFVOV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 10:21:58 -0400
Received: from relay2.sgi.com ([192.48.171.30]:53992 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756254AbYFVOV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 10:21:57 -0400
From: Paul Jackson <pj@sgi.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Jack Steiner" <steiner@sgi.com>,
       "Mike Travis" <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>
Date: Sun, 22 Jun 2008 07:21:57 -0700
Message-Id: <20080622142157.5591.48400.sendpatchset@polaris-admin.engr.sgi.com>
In-Reply-To: <20080622142151.5591.4139.sendpatchset@polaris-admin.engr.sgi.com>
References: <20080622142151.5591.4139.sendpatchset@polaris-admin.engr.sgi.com>
Subject: [PATCH 1/5 v2] x86 boot: e820 code indentation fix
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
