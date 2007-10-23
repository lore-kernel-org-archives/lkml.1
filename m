Return-Path: <linux-kernel-owner+w=401wt.eu-S1752275AbXJWJ5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbXJWJ5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 05:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbXJWJ46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 05:56:58 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:47875
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752553AbXJWJ45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 05:56:57 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] Add section IDs to rapidio.tmpl
Date: Tue, 23 Oct 2007 04:56:24 -0500
User-Agent: KMail/1.9.6
Cc: akpm@linux-foundation.org, mporter@kernel.crashing.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710230456.24310.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

Add section IDs to rapidio.tmpl

Signed-off-by: Rob Landley <rob@landley.net>
---

 Documentation/DocBook/rapidio.tmpl |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -r a868e8217782 Documentation/DocBook/rapidio.tmpl
--- a/Documentation/DocBook/rapidio.tmpl	Mon Oct 22 19:40:02 2007 -0700
+++ b/Documentation/DocBook/rapidio.tmpl	Mon Oct 22 23:45:49 2007 -0500
@@ -77,11 +77,11 @@
   <chapter id="bugs">
      <title>Known Bugs and Limitations</title>
 
-     <sect1>
+     <sect1 id="known_bugs">
      	<title>Bugs</title>
 	  <para>None. ;)</para>
      </sect1>
-     <sect1>
+     <sect1 id="Limitations">
      	<title>Limitations</title>
 	  <para>
 	    <orderedlist>
@@ -100,7 +100,7 @@
 		on devices, request/map memory region resources,
 		and manage mailboxes/doorbells.
 	</para>
-	<sect1>
+	<sect1 id="Functions">
 		<title>Functions</title>
 !Iinclude/linux/rio_drv.h
 !Edrivers/rapidio/rio-driver.c
@@ -116,23 +116,23 @@
      subsystem.
      </para>
 
-     <sect1><title>Structures</title>
+     <sect1 id="Structures"><title>Structures</title>
 !Iinclude/linux/rio.h
      </sect1>
-     <sect1><title>Enumeration and Discovery</title>
+     <sect1 id="Enumeration_and_Discovery"><title>Enumeration and Discovery</title>
 !Idrivers/rapidio/rio-scan.c
      </sect1>
-     <sect1><title>Driver functionality</title>
+     <sect1 id="Driver_functionality"><title>Driver functionality</title>
 !Idrivers/rapidio/rio.c
 !Idrivers/rapidio/rio-access.c
      </sect1>
-     <sect1><title>Device model support</title>
+     <sect1 id="Device_model_support"><title>Device model support</title>
 !Idrivers/rapidio/rio-driver.c
      </sect1>
-     <sect1><title>Sysfs support</title>
+     <sect1 id="Sysfs_support"><title>Sysfs support</title>
 !Idrivers/rapidio/rio-sysfs.c
      </sect1>
-     <sect1><title>PPC32 support</title>
+     <sect1 id="PPC32_support"><title>PPC32 support</title>
 !Iarch/ppc/kernel/rio.c
 !Earch/ppc/syslib/ppc85xx_rio.c
 !Iarch/ppc/syslib/ppc85xx_rio.c

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
