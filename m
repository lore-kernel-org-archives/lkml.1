Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbZKVMR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbZKVMR6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 07:17:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754574AbZKVMR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 07:17:57 -0500
Received: from ns.ariel-networks.com ([122.216.114.210]:37712 "EHLO
	ns.ariel-networks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbZKVMR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 07:17:56 -0500
Date: Sun, 22 Nov 2009 21:18:02 +0900
From: Hiroyasu OHYAMA <ohyama_sec@ariel-networks.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] (Documentation) append more detail explanation to the I/O scheduler API.
Message-ID: <20091122121802.GA4646@ns.ariel-networksc.om>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From: Hiroyasu OHYAMA

 Signed-off-by: Hiroyasu OHYAMA <ohyama_sec@ariel-networks.com>

 I'm sorry, I realized that the patch which I send before is incorrect format
 to send it to lkml.
 So I resend it.

 This patch append more detail explanation to the Documentation of API of I/O scheduler.

 Thank you for reading.

---
diff --git a/Documentation/block/biodoc.txt b/Documentation/block/biodoc.txt
index 8d2158a..7c04f54 100644
--- a/Documentation/block/biodoc.txt
+++ b/Documentation/block/biodoc.txt
@@ -935,7 +935,12 @@ keeping work.
 4.1. I/O scheduler API

  The functions an elevator may implement are: (* are mandatory)
-elevator_merge_fn    called to query requests for merge with a bio
+elevator_merge_fn    called to query requests for merge with a bio. This method
+       have two following works. One is to indicate how to merge request
+       with bio from head or tail. This function doesn't merge them actually,
+       but just indicate direction for merging from head or tail, or that
+       there is no request with that bio can merge. Another work is to get
+       the request object which is merged, if the bio can do.

 elevator_merge_req_fn    called when two requests get merged. the one
         which gets merged into the other one will be


