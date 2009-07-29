Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbZG2VH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbZG2VH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 17:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752357AbZG2VH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 17:07:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41131 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194AbZG2VH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 17:07:57 -0400
Date: Thu, 30 Jul 2009 00:06:46 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: giometti@enneenne.com, linux-kernel@vger.kernel.org
Subject: [PATCH] pps: include linux/types in pps.h
Message-ID: <20090729210646.GA8659@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/pps.h should include linux/types.h before
using types like __u8, so that this header works independently
of include order.
make headers_check complains about this:
include/linux/pps.h:52: found __[us]{8,16,32,64} type
                without #include <linux/types.h>

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/pps.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/pps.h b/include/linux/pps.h
index cfe5c72..0194ab0 100644
--- a/include/linux/pps.h
+++ b/include/linux/pps.h
@@ -22,6 +22,8 @@
 #ifndef _PPS_H_
 #define _PPS_H_
 
+#include <linux/types.h>
+
 #define PPS_VERSION		"5.3.6"
 #define PPS_MAX_SOURCES		16		/* should be enough... */
 
-- 
1.6.2.5
