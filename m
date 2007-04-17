Return-Path: <linux-kernel-owner+w=401wt.eu-S1161199AbXDQT73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161199AbXDQT73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 15:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161039AbXDQT73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 15:59:29 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:55156 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161199AbXDQT72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 15:59:28 -0400
Date: Tue, 17 Apr 2007 14:57:47 -0500
From: Stephen Cameron <steve.cameron@hp.com>
To: linux-kernel@vger.kernel.org
Cc: mike.miller@hp.com
Subject: [PATCH] Documentation: cciss: detecting failed drives
Message-ID: <20070417195747.GA11004@quandary.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Stephen M. Cameron <steve.cameron@hp.com>
Signed-off-by: Stephen M. Cameron <steve.cameron@hp.com>

Document how to detect drive failures for cciss 

---

 Documentation/cciss.txt |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff -puN Documentation/cciss.txt~cciss_vol_status_doc Documentation/cciss.txt
--- linux-2.6.21-rc6/Documentation/cciss.txt~cciss_vol_status_doc	2007-04-13 13:56:17.000000000 -0500
+++ linux-2.6.21-rc6-scameron/Documentation/cciss.txt	2007-04-13 14:01:33.000000000 -0500
@@ -22,14 +22,21 @@ This driver is known to work with the fo
 	* SA E200i
 	* SA E500
 
-If nodes are not already created in the /dev/cciss directory, run as root:
+Detecting drive failures:
+-------------------------
 
-# cd /dev
-# ./MAKEDEV cciss
+To get the status of logical volumes and to detect physical drive 
+failures, you can use the cciss_vol_status program found here:
+http://cciss.sourceforge.net/#cciss_utils
 
 Device Naming:
 --------------
 
+If nodes are not already created in the /dev/cciss directory, run as root:
+
+# cd /dev
+# ./MAKEDEV cciss
+
 You need some entries in /dev for the cciss device.  The MAKEDEV script
 can make device nodes for you automatically.  Currently the device setup
 is as follows:
_
