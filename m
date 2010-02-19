Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab0BSEON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 23:14:13 -0500
Received: from sh.osrg.net ([192.16.179.4]:57890 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517Ab0BSEOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 23:14:12 -0500
Date: Fri, 19 Feb 2010 13:13:45 +0900
To: dhowells@redhat.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH -mm] frv: remove the obsolete and unnecessary DMA API
 comments
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <28355.1266401022@redhat.com>
References: <20100212145830I.fujita.tomonori@lab.ntt.co.jp>
	<28355.1266401022@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100219131335E.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 19 Feb 2010 13:13:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Feb 2010 10:03:42 +0000
David Howells <dhowells@redhat.com> wrote:

> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > pci_dma_sync_single was obsoleted long ago.
> > 
> > All the comments are generic, not architecture specific, simply
> > describes some of the DMA-API (and frv has the same comments in three
> > files). Documentation/DMA-API.txt have more detailed descriptions.
> > 
> > This removes the above obsolete and unnecessary DMA API
> > comments. Let's describe the DMA API in only
> > Documentation/DMA-API.txt.
> 
> I'm okay with this, _provided_ you put a pointer in a banner comment at the
> top of the file to Documentation/DMA-API.txt.

How about this?

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] frv: add a pointer to Documentation/DMA-API.txt

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/frv/include/asm/dma-mapping.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/frv/include/asm/dma-mapping.h b/arch/frv/include/asm/dma-mapping.h
index 20cca40..6af5d83 100644
--- a/arch/frv/include/asm/dma-mapping.h
+++ b/arch/frv/include/asm/dma-mapping.h
@@ -7,6 +7,11 @@
 #include <asm/scatterlist.h>
 #include <asm/io.h>
 
+/*
+ * See Documentation/DMA-API.txt for the description of how the
+ * following DMA API should work.
+ */
+
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 
-- 
1.6.5

