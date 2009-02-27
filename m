Return-Path: <linux-kernel-owner+w=401wt.eu-S1759409AbZB0UBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409AbZB0UBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 15:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbZB0UBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 15:01:39 -0500
Received: from mga03.intel.com ([143.182.124.21]:17896 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbZB0UBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 15:01:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,278,1233561600"; 
   d="scan'208";a="115181760"
From: Chris Leech <christopher.leech@intel.com>
Subject: [PATCH 1/2] net headers: cleanup dcbnl.h
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Fri, 27 Feb 2009 12:01:36 -0800
Message-ID: <20090227200136.31557.53143.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) add an include for <linux/types.h>
2) change dcbmsg.dcb_family from unsigned char to __u8 to be more
   consistent with use of kernel types

Signed-off-by: Chris Leech <christopher.leech@intel.com>
---

 include/linux/dcbnl.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/dcbnl.h b/include/linux/dcbnl.h
index b0ef274..7d2e100 100644
--- a/include/linux/dcbnl.h
+++ b/include/linux/dcbnl.h
@@ -20,10 +20,12 @@
 #ifndef __LINUX_DCBNL_H__
 #define __LINUX_DCBNL_H__
 
+#include <linux/types.h>
+
 #define DCB_PROTO_VERSION 1
 
 struct dcbmsg {
-	unsigned char      dcb_family;
+	__u8               dcb_family;
 	__u8               cmd;
 	__u16              dcb_pad;
 };

