Return-Path: <linux-kernel-owner+w=401wt.eu-S932889AbXGZImU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932889AbXGZImU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 04:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757238AbXGZImJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 04:42:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:29083 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756781AbXGZImH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 04:42:07 -0400
Date: Thu, 26 Jul 2007 11:42:11 +0300
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Cc: James Bottomley <James.Bottomley@steeleye.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org,
       Mike Christie <michaelc@cs.wisc.edu>, Roland Dreier <rdreier@cisco.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       general@lists.openfabrics.org
Subject: [PATCH trivial v2] add includes to scsi_transport_iscsi.h
Message-ID: <20070726084211.GB22557@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <20070725110907.GF3826@mellanox.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070725110907.GF3826@mellanox.co.il>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

scsi/scsi_transport_iscsi.h uses struct mutex and struct list_head,
so while linux/mutex.h and linux/list.h seem to be pulled in indirectly
by one of the headers it includes, the right thing
is to include linux/mutex.h and linus/list.h directly.

Signed-off-by: Michael S. Tsirkin <mst@dev.mellanox.co.il>

---

Changelog:

Mike Christie pointed out that linux/list.h is missing too.

diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 706c0cd..7ff6199 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -24,6 +24,8 @@
 #define SCSI_TRANSPORT_ISCSI_H
 
 #include <linux/device.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
 #include <scsi/iscsi_if.h>
 
 struct scsi_transport_template;

-- 
MST
