Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463Ab0BMQC5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 11:02:57 -0500
Received: from mail-pz0-f197.google.com ([209.85.222.197]:64810 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab0BMQCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 11:02:50 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 3/9] of: protect linux/of.h with CONFIG_OF
To: monstr@monstr.eu, sfr@canb.auug.org.au, benh@kernel.crashing.org,
       jeremy.kerr@canonical.com, davem@davemloft.net,
       microblaze-uclinux@itee.uq.edu.au, linuxppc-dev@ozlabs.org,
       sparclinux@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
       linux-kernel@vger.kernel.org
Date: Sat, 13 Feb 2010 09:02:42 -0700
Message-ID: <20100213160242.4767.57641.stgit@angua>
In-Reply-To: <20100213154838.4767.83881.stgit@angua>
References: <20100213154838.4767.83881.stgit@angua>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Kerr <jeremy.kerr@canonical.com>

For platforms that have CONFIG_OF optional, we need to make the contents
of linux/of.h conditional on CONFIG_OF.

Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 include/linux/of.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/of.h b/include/linux/of.h
index 5c7b6a6..48b0ee6 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -22,6 +22,8 @@
 
 #include <asm/byteorder.h>
 
+#ifdef CONFIG_OF
+
 typedef u32 phandle;
 typedef u32 ihandle;
 
@@ -194,4 +196,5 @@ extern void of_attach_node(struct device_node *);
 extern void of_detach_node(struct device_node *);
 #endif
 
+#endif /* CONFIG_OF */
 #endif /* _LINUX_OF_H */

