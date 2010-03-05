Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab0CERra (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 12:47:30 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:20325 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039Ab0CERr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 12:47:27 -0500
Subject: [PATCH v2 1/7] resource: expand IORESOURCE_TYPE_BITS to make room for
	bus resource type
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Len Brown <lenb@kernel.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adam Belay <abelay@mit.edu>
Date: Fri, 05 Mar 2010 10:47:26 -0700
Message-ID: <20100305174726.21946.9732.stgit@bob.kio>
In-Reply-To: <20100305174656.21946.93874.stgit@bob.kio>
References: <20100305174656.21946.93874.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No functional change; this just makes room for another resource type.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 include/linux/ioport.h |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)


diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index dda9841..b126209 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -34,20 +34,20 @@ struct resource_list {
  */
 #define IORESOURCE_BITS		0x000000ff	/* Bus-specific bits */
 
-#define IORESOURCE_TYPE_BITS	0x00000f00	/* Resource type */
+#define IORESOURCE_TYPE_BITS	0x00001f00	/* Resource type */
 #define IORESOURCE_IO		0x00000100
 #define IORESOURCE_MEM		0x00000200
 #define IORESOURCE_IRQ		0x00000400
 #define IORESOURCE_DMA		0x00000800
 
-#define IORESOURCE_PREFETCH	0x00001000	/* No side effects */
-#define IORESOURCE_READONLY	0x00002000
-#define IORESOURCE_CACHEABLE	0x00004000
-#define IORESOURCE_RANGELENGTH	0x00008000
-#define IORESOURCE_SHADOWABLE	0x00010000
+#define IORESOURCE_PREFETCH	0x00002000	/* No side effects */
+#define IORESOURCE_READONLY	0x00004000
+#define IORESOURCE_CACHEABLE	0x00008000
+#define IORESOURCE_RANGELENGTH	0x00010000
+#define IORESOURCE_SHADOWABLE	0x00020000
 
-#define IORESOURCE_SIZEALIGN	0x00020000	/* size indicates alignment */
-#define IORESOURCE_STARTALIGN	0x00040000	/* start field is alignment */
+#define IORESOURCE_SIZEALIGN	0x00040000	/* size indicates alignment */
+#define IORESOURCE_STARTALIGN	0x00080000	/* start field is alignment */
 
 #define IORESOURCE_MEM_64	0x00100000
 

