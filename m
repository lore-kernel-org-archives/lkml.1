Return-Path: <linux-kernel-owner+w=401wt.eu-S1760894AbXHAJOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760894AbXHAJOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 05:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758860AbXHAJOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 05:14:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757441AbXHAJOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 05:14:02 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Make BSG declarations dependent on CONFIG_BLOCK
To: torvalds@osdl.org, akpm@osdl.org, James.Bottomley@SteelEye.com,
       jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Wed, 01 Aug 2007 10:13:53 +0100
Message-ID: <20070801091353.10608.32356.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Make BSG function declarations dependent on CONFIG_BLOCK as they are not
compilable if the block layer is compiled out.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/bsg.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/bsg.h b/include/linux/bsg.h
index 102dc09..e917c41 100644
--- a/include/linux/bsg.h
+++ b/include/linux/bsg.h
@@ -47,6 +47,7 @@ struct sg_io_v4 {
 };
 
 #ifdef __KERNEL__
+#ifdef CONFIG_BLOCK
 
 #if defined(CONFIG_BLK_DEV_BSG)
 struct bsg_class_device {
@@ -68,6 +69,7 @@ static inline void bsg_unregister_queue(struct request_queue *rq)
 }
 #endif
 
+#endif /* CONFIG_BLOCK */
 #endif /* __KERNEL__ */
 
 #endif

