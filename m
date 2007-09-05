Return-Path: <linux-kernel-owner+w=401wt.eu-S1757334AbXIEPYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbXIEPYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 11:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756552AbXIEPX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 11:23:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756535AbXIEPX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 11:23:56 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Make BSG declarations dependent on CONFIG_BLOCK
To: jens.axboe@oracle.com
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 05 Sep 2007 16:23:06 +0100
Message-ID: <20070905152306.3282.70289.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.13
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
index 60e377b..28f5d44 100644
--- a/include/linux/bsg.h
+++ b/include/linux/bsg.h
@@ -52,6 +52,7 @@ struct sg_io_v4 {
 };
 
 #ifdef __KERNEL__
+#ifdef CONFIG_BLOCK
 
 #if defined(CONFIG_BLK_DEV_BSG)
 struct bsg_class_device {
@@ -73,6 +74,7 @@ static inline void bsg_unregister_queue(struct request_queue *rq)
 }
 #endif
 
+#endif /* CONFIG_BLOCK */
 #endif /* __KERNEL__ */
 
 #endif

