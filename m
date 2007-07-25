Return-Path: <linux-kernel-owner+w=401wt.eu-S1764370AbXGYLJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764370AbXGYLJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 07:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759654AbXGYLJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 07:09:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:16025 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759413AbXGYLJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 07:09:08 -0400
Date: Wed, 25 Jul 2007 14:09:08 +0300
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: James Bottomley <James.Bottomley@steeleye.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org,
       Mike Christie <michaelc@cs.wisc.edu>, Roland Dreier <rdreier@cisco.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       general@lists.openfabrics.org
Subject: [PATCH trivial] include linux/mutex.h from scsi_transport_iscsi.h
Message-ID: <20070725110907.GF3826@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

scsi/scsi_transport_iscsi.h uses struct mutex, so while
linux/mutex.h seems to be pulled in indirectly
by one of the headers it includes, the right thing
is to include linux/mutex.h directly.

Signed-off-by: Michael S. Tsirkin <mst@dev.mellanox.co.il>

---

diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 706c0cd..7530e98 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -24,6 +24,7 @@
 #define SCSI_TRANSPORT_ISCSI_H
 
 #include <linux/device.h>
+#include <linux/mutex.h>
 #include <scsi/iscsi_if.h>
 
 struct scsi_transport_template;


-- 
MST
