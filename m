Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbYJBQq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbYJBQq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 12:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbYJBQqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 12:46:20 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:47317 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766AbYJBQqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 12:46:19 -0400
Date: Thu, 2 Oct 2008 09:41:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, mouw@nl.linux.org
Subject: [PATCH] docbook: update procfs credits
Message-Id: <20081002094150.715b6216.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Update Erik Mouw's email address & affiliation in DocBook.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Erik Mouw <mouw@nl.linux.org>
---
 Documentation/DocBook/procfs-guide.tmpl |   29 ++++++++++-------------------
 Documentation/DocBook/procfs_example.c  |   20 ++++----------------
 2 files changed, 14 insertions(+), 35 deletions(-)

--- linux-2.6.27-rc8-git3.orig/Documentation/DocBook/procfs-guide.tmpl
+++ linux-2.6.27-rc8-git3/Documentation/DocBook/procfs-guide.tmpl
@@ -14,17 +14,20 @@
 	<othername>(J.A.K.)</othername>
 	<surname>Mouw</surname>
 	<affiliation>
-	  <orgname>Delft University of Technology</orgname>
-	  <orgdiv>Faculty of Information Technology and Systems</orgdiv>
 	  <address>
-            <email>J.A.K.Mouw@its.tudelft.nl</email>
-            <pob>PO BOX 5031</pob>
-            <postcode>2600 GA</postcode>
-            <city>Delft</city>
-            <country>The Netherlands</country>
+            <email>mouw@nl.linux.org</email>
           </address>
 	</affiliation>
       </author>
+      <othercredit>
+	<contrib>
+	This software and documentation were written while working on the
+	LART computing board
+	(<ulink url="http://www.lartmaker.nl/">http://www.lartmaker.nl/</ulink>),
+	which was sponsored by the Delt University of Technology projects
+	Mobile Multi-media Communications and Ubiquitous Communications.
+	</contrib>
+      </othercredit>
     </authorgroup>
 
     <revhistory>
@@ -109,18 +112,6 @@
     </para>
 
     <para>
-      This documentation was written while working on the LART
-      computing board (<ulink
-      url="http://www.lart.tudelft.nl/">http://www.lart.tudelft.nl/</ulink>),
-      which is sponsored by the Mobile Multi-media Communications
-      (<ulink
-      url="http://www.mmc.tudelft.nl/">http://www.mmc.tudelft.nl/</ulink>)
-      and Ubiquitous Communications (<ulink
-      url="http://www.ubicom.tudelft.nl/">http://www.ubicom.tudelft.nl/</ulink>)
-      projects.
-    </para>
-
-    <para>
       Erik
     </para>
   </preface>
--- linux-2.6.27-rc8-git3.orig/Documentation/DocBook/procfs_example.c
+++ linux-2.6.27-rc8-git3/Documentation/DocBook/procfs_example.c
@@ -1,28 +1,16 @@
 /*
  * procfs_example.c: an example proc interface
  *
- * Copyright (C) 2001, Erik Mouw (J.A.K.Mouw@its.tudelft.nl)
+ * Copyright (C) 2001, Erik Mouw (mouw@nl.linux.org)
  *
  * This file accompanies the procfs-guide in the Linux kernel
  * source. Its main use is to demonstrate the concepts and
  * functions described in the guide.
  *
  * This software has been developed while working on the LART
- * computing board (http://www.lart.tudelft.nl/), which is
- * sponsored by the Mobile Multi-media Communications
- * (http://www.mmc.tudelft.nl/) and Ubiquitous Communications 
- * (http://www.ubicom.tudelft.nl/) projects.
- *
- * The author can be reached at:
- *
- *  Erik Mouw
- *  Information and Communication Theory Group
- *  Faculty of Information Technology and Systems
- *  Delft University of Technology
- *  P.O. Box 5031
- *  2600 GA Delft
- *  The Netherlands
- *
+ * computing board (http://www.lartmaker.nl), which was sponsored
+ * by the Delt University of Technology projects Mobile Multi-media
+ * Communications and Ubiquitous Communications.
  *
  * This program is free software; you can redistribute
  * it and/or modify it under the terms of the GNU General
