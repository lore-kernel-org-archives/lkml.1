Return-Path: <linux-kernel-owner+w=401wt.eu-S1750932AbZKUFoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750932AbZKUFoK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 00:44:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750762AbZKUFoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 00:44:10 -0500
Received: from ns.ariel-networks.com ([122.216.114.210]:42377 "EHLO
	ns.ariel-networks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbZKUFoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 00:44:09 -0500
X-Greylist: delayed 1684 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Nov 2009 00:44:09 EST
Date: Sat, 21 Nov 2009 14:16:11 +0900
From: Hiroyasu OHYAMA <ohyama_sec@ariel-networks.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] (Documentation) append more detail explanation to the I/O scheduler API.
Message-ID: <20091121051611.GA12131@ns.ariel-networksc.om>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
