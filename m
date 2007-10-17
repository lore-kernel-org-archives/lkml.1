Return-Path: <linux-kernel-owner+w=401wt.eu-S1758808AbXJQGVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808AbXJQGVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 02:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbXJQGVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 02:21:44 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:46978 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbXJQGVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 02:21:42 -0400
Message-ID: <4715A9C1.9090106@linux.vnet.ibm.com>
Date: Wed, 17 Oct 2007 11:50:49 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: 2.6.23-git-10 Build Failure on powerpc - asm-powerpc/dma_mapping.h
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Build fails on the powerpc fails with 2.6.23-git10

  CC      init/main.o
In file included from include/linux/dma-mapping.h:42,
                 from include/linux/dmaengine.h:29,
                 from include/linux/skbuff.h:29,
                 from include/linux/netlink.h:155,
                 from include/linux/genetlink.h:4,
                 from include/net/genetlink.h:4,
                 from include/linux/taskstats_kern.h:12,
                 from init/main.c:45:
include/asm/dma-mapping.h: In function `dma_unmap_page':
include/asm/dma-mapping.h:14: error: implicit declaration of function `get_dma_ops'
include/asm/dma-mapping.h:14: warning: initialization makes pointer from integer without a cast
include/asm/dma-mapping.h:17: error: dereferencing pointer to incomplete type
include/asm/dma-mapping.h: At top level:
include/asm/dma-mapping.h:21: warning: `struct scatterlist' declared inside parameter list
include/asm/dma-mapping.h:21: warning: its scope is only this definition or declaration, which is probably not what you want
include/asm/dma-mapping.h: In function `dma_map_sg':
include/asm/dma-mapping.h:23: warning: initialization makes pointer from integer without a cast
include/asm/dma-mapping.h:26: error: dereferencing pointer to incomplete type
include/asm/dma-mapping.h: At top level:
include/asm/dma-mapping.h:31: warning: `struct scatterlist' declared inside parameter list
include/asm/dma-mapping.h: In function `dma_unmap_sg':
include/asm/dma-mapping.h:33: warning: initialization makes pointer from integer without a cast
include/asm/dma-mapping.h:36: error: dereferencing pointer to incomplete type
include/asm/dma-mapping.h: In function `dma_sync_single_for_cpu':
include/asm/dma-mapping.h:167: error: implicit declaration of function `__dma_sync'
include/asm/dma-mapping.h:167: error: implicit declaration of function `bus_to_virt'
include/asm/dma-mapping.h: At top level:
include/asm/dma-mapping.h:180: warning: `struct scatterlist' declared inside parameter list
include/asm/dma-mapping.h: In function `dma_sync_sg_for_cpu':
include/asm/dma-mapping.h:187: error: implicit declaration of function `for_each_sg'
include/asm/dma-mapping.h:188: error: parse error before "__dma_sync_page"
include/asm/dma-mapping.h: At top level:
include/asm/dma-mapping.h:193: warning: `struct scatterlist' declared inside parameter list
include/asm/dma-mapping.h: In function `dma_sync_sg_for_device':
include/asm/dma-mapping.h:201: error: parse error before "__dma_sync_page"
include/asm/dma-mapping.h: In function `dma_mapping_error':
include/asm/dma-mapping.h:207: error: `DMA_ERROR_CODE' undeclared (first use in this function)
include/asm/dma-mapping.h:207: error: (Each undeclared identifier is reported only once
include/asm/dma-mapping.h:207: error: for each function it appears in.)
In file included from include/linux/dma-mapping.h:42,
                 from include/linux/dmaengine.h:29,
                 from include/linux/skbuff.h:29,
                 from include/linux/netlink.h:155,
                 from include/linux/genetlink.h:4,
                 from include/net/genetlink.h:4,
                 from include/linux/taskstats_kern.h:12,
                 from init/main.c:45:
include/asm/dma-mapping.h:259:2: #endif without #if
include/asm/dma-mapping.h:260:2: #endif without #if
make[1]: *** [init/main.o] Error 1
make: *** [init] Error 2
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
