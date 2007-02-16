Return-Path: <linux-kernel-owner+w=401wt.eu-S1751823AbXBPBJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbXBPBJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 20:09:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbXBPBJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 20:09:30 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:49585 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbXBPBJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 20:09:30 -0500
Date: Thu, 15 Feb 2007 17:04:14 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@osdl.org>, tytso@mit.edu
Subject: [PATCH] update Doc/oops-tracing.txt for TAINT_USER
Message-Id: <20070215170414.56e6193b.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add TAINT_USER description to Tainted flags in oops-tracing.txt.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/oops-tracing.txt |    3 +++
 1 file changed, 3 insertions(+)

--- linux-2.6.20-git9.orig/Documentation/oops-tracing.txt
+++ linux-2.6.20-git9/Documentation/oops-tracing.txt
@@ -234,6 +234,9 @@ characters, each representing a particul
   6: 'B' if a page-release function has found a bad page reference or
      some unexpected page flags.
 
+  7: 'U' if a user specifically requested that the Tainted flag be set,
+     ' ' otherwise.
+
 The primary reason for the 'Tainted: ' string is to tell kernel
 debuggers if this is a clean kernel or if anything unusual has
 occurred.  Tainting is permanent: even if an offending module is
