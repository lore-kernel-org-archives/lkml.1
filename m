Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab0BMQDV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 11:03:21 -0500
Received: from mail-pz0-f197.google.com ([209.85.222.197]:45038 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404Ab0BMQDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 11:03:17 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 9/9] of: remove undefined request_OF_resource &
	release_OF_resource
To: monstr@monstr.eu, sfr@canb.auug.org.au, benh@kernel.crashing.org,
       jeremy.kerr@canonical.com, davem@davemloft.net,
       microblaze-uclinux@itee.uq.edu.au, linuxppc-dev@ozlabs.org,
       sparclinux@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
       linux-kernel@vger.kernel.org
Date: Sat, 13 Feb 2010 09:03:15 -0700
Message-ID: <20100213160314.4767.93924.stgit@angua>
In-Reply-To: <20100213154838.4767.83881.stgit@angua>
References: <20100213154838.4767.83881.stgit@angua>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neither request_OF_resource or release_OF_resource are defined
anywhere.  Remove the declarations.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 arch/microblaze/include/asm/prom.h |    4 ----
 arch/powerpc/include/asm/prom.h    |    5 -----
 2 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/arch/microblaze/include/asm/prom.h b/arch/microblaze/include/asm/prom.h
index aa1a437..03f45a9 100644
--- a/arch/microblaze/include/asm/prom.h
+++ b/arch/microblaze/include/asm/prom.h
@@ -31,10 +31,6 @@
 /* Other Prototypes */
 extern int early_uartlite_console(void);
 
-extern struct resource *request_OF_resource(struct device_node *node,
-				int index, const char *name_postfix);
-extern int release_OF_resource(struct device_node *node, int index);
-
 /*
  * OF address retreival & translation
  */
diff --git a/arch/powerpc/include/asm/prom.h b/arch/powerpc/include/asm/prom.h
index 7f9a50a..ddd408a 100644
--- a/arch/powerpc/include/asm/prom.h
+++ b/arch/powerpc/include/asm/prom.h
@@ -39,11 +39,6 @@ extern struct device_node* pci_device_to_OF_node(struct pci_dev *);
 extern void pci_create_OF_bus_map(void);
 #endif
 
-extern struct resource *request_OF_resource(struct device_node* node,
-				int index, const char* name_postfix);
-extern int release_OF_resource(struct device_node* node, int index);
-
-
 /*
  * OF address retreival & translation
  */

