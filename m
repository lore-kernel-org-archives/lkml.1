Return-Path: <linux-kernel-owner+w=401wt.eu-S1767387AbXECFXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767387AbXECFXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 01:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767388AbXECFXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 01:23:01 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:20162 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767387AbXECFXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 01:23:00 -0400
Date: Wed, 2 May 2007 22:26:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: tglx@linutronix.de, akpm <akpm@linux-foundation.org>
Subject: [PATCH] docbook: librs typo fixes
Message-Id: <20070502222610.5cb553b8.randy.dunlap@oracle.com>
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

librs docbook typo fixes.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/librs.tmpl |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- linux-2621-g4.orig/Documentation/DocBook/librs.tmpl
+++ linux-2621-g4/Documentation/DocBook/librs.tmpl
@@ -79,12 +79,12 @@
   <chapter id="usage">
      	<title>Usage</title>
 	<para>
-		This chapter provides examples how to use the library.
+		This chapter provides examples of how to use the library.
 	</para>
 	<sect1>
 		<title>Initializing</title>
 		<para>
-			The init function init_rs returns a pointer to a
+			The init function init_rs returns a pointer to an
 			rs decoder structure, which holds the necessary
 			information for encoding, decoding and error correction
 			with the given polynomial. It either uses an existing
@@ -98,10 +98,10 @@
 static struct rs_control *rs_decoder;
 
 /* Symbolsize is 10 (bits)
- * Primitve polynomial is x^10+x^3+1
+ * Primitive polynomial is x^10+x^3+1
  * first consecutive root is 0
- * primitve element to generate roots = 1
- * generator polinomial degree (number of roots) = 6
+ * primitive element to generate roots = 1
+ * generator polynomial degree (number of roots) = 6
  */
 rs_decoder = init_rs (10, 0x409, 0, 1, 6);
 		</programlisting>
@@ -116,12 +116,12 @@ rs_decoder = init_rs (10, 0x409, 0, 1, 6
 		</para>
 		<para>
 			The expanded data can be inverted on the fly by
-			providing a non zero inversion mask. The expanded data is
+			providing a non-zero inversion mask. The expanded data is
 			XOR'ed with the mask. This is used e.g. for FLASH
 			ECC, where the all 0xFF is inverted to an all 0x00.
 			The Reed-Solomon code for all 0x00 is all 0x00. The
 			code is inverted before storing to FLASH so it is 0xFF
-			too. This prevent's that reading from an erased FLASH
+			too. This prevents that reading from an erased FLASH
 			results in ECC errors.
 		</para>
 		<para>
@@ -273,7 +273,7 @@ free_rs(rs_decoder);
  		May be used under the terms of the GNU General Public License (GPL)
 	</programlisting>
 	<para>
-		The wrapper functions and interfaces are written by Thomas Gleixner
+		The wrapper functions and interfaces are written by Thomas Gleixner.
 	</para>
 	<para>
 		Many users have provided bugfixes, improvements and helping hands for testing.
