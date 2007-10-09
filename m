Return-Path: <linux-kernel-owner+w=401wt.eu-S1753893AbXJIHf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbXJIHf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 03:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbXJIHfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 03:35:13 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:48009
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752841AbXJIHfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 03:35:12 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: akpm@linux-foundation.org
Subject: [PATCH] Add recommended section IDs to deviceiobook.tmpl
Date: Tue, 9 Oct 2007 02:35:07 -0500
User-Agent: KMail/1.9.6
Cc: matthew@wil.cx, alan@redhat.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710090235.08063.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

Add recommended section ID tags to deviceiobook.tmpl

Signed-off-by: Rob Landley <rob@landley.net>
---

Because otherwise the link #anchors in the html vary from build to build.

 Documentation/DocBook/deviceiobook.tmpl |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -r a26a53ed1101 Documentation/DocBook/deviceiobook.tmpl
--- a/Documentation/DocBook/deviceiobook.tmpl	Sun Oct 07 16:42:22 2007 -0700
+++ b/Documentation/DocBook/deviceiobook.tmpl	Tue Oct 09 02:32:12 2007 -0500
@@ -85,7 +85,7 @@
 
   <chapter id="mmio">
     <title>Memory Mapped IO</title>
-    <sect1>
+    <sect1 id="getting_access_to_the_device">
       <title>Getting Access to the Device</title>
       <para>
 	The most widely supported form of IO is memory mapped IO.
@@ -114,7 +114,7 @@
       </para>
     </sect1>
 
-    <sect1>
+    <sect1 id="accessing_the_device">
       <title>Accessing the device</title>
       <para>
 	The part of the interface most used by drivers is reading and
@@ -272,9 +272,9 @@ CPU B:  spin_unlock_irqrestore(&amp;dev_
 
   </chapter>
 
-  <chapter>
+  <chapter id="port_space_accesses">
     <title>Port Space Accesses</title>
-    <sect1>
+    <sect1 id="port_space_explained">
       <title>Port Space Explained</title>
 
       <para>
@@ -291,7 +291,7 @@ CPU B:  spin_unlock_irqrestore(&amp;dev_
       </para>
 
     </sect1>
-    <sect1>
+    <sect1 id="accessing_port_space">
       <title>Accessing Port Space</title>
       <para>
 	Accesses to this space are provided through a set of functions

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
