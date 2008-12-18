Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752510AbYLRS6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510AbYLRS6n (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 13:58:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbYLRS6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 13:58:32 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:47070 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbYLRS6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 13:58:31 -0500
Date: Thu, 18 Dec 2008 10:57:09 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-doc@vger.kernel.org, akpm <akpm@linux-foundation.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] documentation: how to use DOC: section blocks
Message-Id: <20081218105709.a9733304.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.494A9D08.0233:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add info on how to use DOC: sections in kernel-doc.
DOC: sections enable the addition of inline source file comments
that are general in nature instead of being specific to a
function, struct, union, enum, or typedef.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Johannes Berg <johannes@sipsolutions.net>
---
 Documentation/kernel-doc-nano-HOWTO.txt |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- linux-next-20081218.orig/Documentation/kernel-doc-nano-HOWTO.txt
+++ linux-next-20081218/Documentation/kernel-doc-nano-HOWTO.txt
@@ -282,6 +282,32 @@ struct my_struct {
 };
 
 
+Including documentation blocks in source files
+----------------------------------------------
+
+To facilitate having source code and comments close together, you can
+include kernel-doc documentation blocks that are free-form comments
+instead of being kernel-doc for functions, structures, unions,
+enums, or typedefs.  This could be used for something like a
+theory of operation for a driver or library code, for example.
+
+This is done by using a DOC: section keyword with a section title.  E.g.:
+
+/**
+ * DOC: Theory of Operation
+ *
+ * The whizbang foobar is a dilly of a gizmo.  It can do whatever you
+ * want it to do, at any time.  It reads your mind.  Here's how it works.
+ *
+ * foo bar splat
+ *
+ * The only drawback to this gizmo is that is can sometimes damage
+ * hardware, software, or its subject(s).
+ */
+
+DOC: sections are used in SGML templates files as indicated below.
+
+
 How to make new SGML template files
 -----------------------------------
 
@@ -302,6 +328,9 @@ exported using EXPORT_SYMBOL.
 !F<filename> <function [functions...]> is replaced by the
 documentation, in <filename>, for the functions listed.
 
+!P<filename> <section title> is replaced by the contents of the DOC:
+section titled <section title> from <filename>.
+Spaces are allowed in <section title>; do not quote the <section title>.
 
 Tim.
 */ <twaugh@redhat.com>
