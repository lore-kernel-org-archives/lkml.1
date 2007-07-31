Return-Path: <linux-kernel-owner+w=401wt.eu-S941359AbXGaCjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941359AbXGaCjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764956AbXGaCjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:39:13 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42614 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790AbXGaCjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:39:11 -0400
Date: Tue, 31 Jul 2007 11:40:07 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "tony.luck@intel.com" <tony.luck@intel.com>,
       "Zoltan.Menyhart@bull.net" <Zoltan.Menyhart@bull.net>,
       Christoph Lameter <clameter@sgi.com>
Subject: [PATCH] flush icache before set_pte take6. [3/4] add montecito
 brand name
Message-Id: <20070731114007.b3c62cd3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070731113543.93ffd964.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070731113543.93ffd964.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add Brand name "Montecito" to cpuinfo.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 arch/ia64/kernel/setup.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.23-rc1.test/arch/ia64/kernel/setup.c
===================================================================
--- linux-2.6.23-rc1.test.orig/arch/ia64/kernel/setup.c
+++ linux-2.6.23-rc1.test/arch/ia64/kernel/setup.c
@@ -705,7 +705,8 @@ get_model_name(__u8 family, __u8 model)
 			case 0: memcpy(brand, "McKinley", 9); break;
 			case 1: memcpy(brand, "Madison", 8); break;
 			case 2: memcpy(brand, "Madison up to 9M cache", 23); break;
-		}
+		} else if (family == 0x20)
+			memcpy(brand, "Montecito", 10);
 	}
 	for (i = 0; i < MAX_BRANDS; i++)
 		if (strcmp(brandname[i], brand) == 0)

