Return-Path: <linux-kernel-owner+w=401wt.eu-S1758598AbXJNF5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598AbXJNF5c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 01:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328AbXJNF5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 01:57:25 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:56634
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbXJNF5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 01:57:24 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Add section IDs to Documentation/DocBook/filesystems.tmpl
Date: Sun, 14 Oct 2007 00:57:19 -0500
User-Agent: KMail/1.9.6
Cc: akpm@linux-foundation.org, rgammans@computer-surgery.co.uk, sct@redhat.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710140057.20134.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

Add recommended section IDs to Documentation/DocBook/filesystems.tmpl

Signed-off-by: Rob Landley <rob@landley.net>
---

 Documentation/DocBook/filesystems.tmpl |   36 +++++++++++------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff -r 79f0ea1e0e70 Documentation/DocBook/filesystems.tmpl
--- a/Documentation/DocBook/filesystems.tmpl	Tue Oct 09 21:00:40 2007 +0000
+++ b/Documentation/DocBook/filesystems.tmpl	Sat Oct 13 23:16:49 2007 -0500
@@ -40,25 +40,25 @@
 
   <chapter id="vfs">
      <title>The Linux VFS</title>
-     <sect1><title>The Filesystem types</title>
+     <sect1 id="the_filesystem_types"><title>The Filesystem types</title>
 !Iinclude/linux/fs.h
      </sect1>
-     <sect1><title>The Directory Cache</title>
+     <sect1 id="the_directory_cache"><title>The Directory Cache</title>
 !Efs/dcache.c
 !Iinclude/linux/dcache.h
      </sect1>
-     <sect1><title>Inode Handling</title>
+     <sect1 id="inode_handling"><title>Inode Handling</title>
 !Efs/inode.c
 !Efs/bad_inode.c
      </sect1>
-     <sect1><title>Registration and Superblocks</title>
+     <sect1 id="registration_and_superblocks"><title>Registration and Superblocks</title>
 !Efs/super.c
      </sect1>
-     <sect1><title>File Locks</title>
+     <sect1 id="file_locks"><title>File Locks</title>
 !Efs/locks.c
 !Ifs/locks.c
      </sect1>
-     <sect1><title>Other Functions</title>
+     <sect1 id="other_functions"><title>Other Functions</title>
 !Efs/mpage.c
 !Efs/namei.c
 !Efs/buffer.c
@@ -73,11 +73,11 @@
   <chapter id="proc">
      <title>The proc filesystem</title>
 
-     <sect1><title>sysctl interface</title>
+     <sect1 id="sysctl_interface"><title>sysctl interface</title>
 !Ekernel/sysctl.c
      </sect1>
 
-     <sect1><title>proc filesystem interface</title>
+     <sect1 id="proc_filesystem_interface"><title>proc filesystem interface</title>
 !Ifs/proc/base.c
      </sect1>
   </chapter>
@@ -92,7 +92,7 @@
   <chapter id="debugfs">
      <title>The debugfs filesystem</title>
 
-     <sect1><title>debugfs interface</title>
+     <sect1 id="debugfs_interface"><title>debugfs interface</title>
 !Efs/debugfs/inode.c
 !Efs/debugfs/file.c
      </sect1>
@@ -134,9 +134,9 @@
 
   <title>The Linux Journalling API</title>
 
-    <sect1>
+    <sect1 id="journaling_overview">
      <title>Overview</title>
-    <sect2>
+    <sect2 id="journaling_details">
      <title>Details</title>
 <para>
 The journalling layer is  easy to use. You need to
@@ -307,7 +307,7 @@ particular inode.
 
     </sect2>
 
-    <sect2>
+    <sect2 id="jbd_summary">
      <title>Summary</title>
 <para>
 Using the journal is a matter of wrapping the different context changes,
@@ -349,7 +349,7 @@ an example.
 
     </sect1>
 
-    <sect1>
+    <sect1 id="data_types">
      <title>Data Types</title>
      <para>
 	The journalling layer uses typedefs to 'hide' the concrete definitions
@@ -358,27 +358,27 @@ an example.
 
 	Obviously the hiding is not enforced as this is 'C'.
      </para>
-	<sect2><title>Structures</title>
+	<sect2 id="structures"><title>Structures</title>
 !Iinclude/linux/jbd.h
 	</sect2>
     </sect1>
 
-    <sect1>
+    <sect1 id="functions">
      <title>Functions</title>
      <para>
 	The functions here are split into two groups those that
 	affect a journal as a whole, and those which are used to
 	manage transactions
      </para>
-	<sect2><title>Journal Level</title>
+	<sect2 id="journal_level"><title>Journal Level</title>
 !Efs/jbd/journal.c
 !Ifs/jbd/recovery.c
 	</sect2>
-	<sect2><title>Transasction Level</title>
+	<sect2 id="transaction_level"><title>Transasction Level</title>
 !Efs/jbd/transaction.c
 	</sect2>
     </sect1>
-    <sect1>
+    <sect1 id="see_also">
      <title>See also</title>
 	<para>
 	  <citation>

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
