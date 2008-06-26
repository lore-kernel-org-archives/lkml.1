Return-Path: <linux-kernel-owner+w=401wt.eu-S1755759AbYFZHz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbYFZHz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 03:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbYFZHzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 03:55:20 -0400
Received: from [194.117.236.238] ([194.117.236.238]:48025 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbYFZHzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 03:55:18 -0400
Date: Thu, 26 Jun 2008 10:54:34 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, rmh3093@gmail.com, penberg@cs.helsinki.fi,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Fix and clean top .gitignore
Message-ID: <20080626105434.60f7e765@linux360.ro>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmlinux* rule because it matches too many useful files, replacing
it with rules matching filetype by filename (e.g. *.gz). Also unignored
.mailmap from the top directory. Added a comment telling the user how to
check for tracked files being ignored.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 .gitignore |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/.gitignore b/.gitignore
index 9bb1cb6..869e1a3 100644
--- a/.gitignore
+++ b/.gitignore
@@ -3,6 +3,10 @@
 # subdirectories here. Add them in the ".gitignore" file
 # in that subdirectory instead.
 #
+# NOTE! Please use 'git-ls-files -i --exclude-standard'
+# command after changing this file, to see if there are
+# any tracked files which get ignored after the change.
+#
 # Normal rules
 #
 .*
@@ -18,19 +22,21 @@
 *.lst
 *.symtypes
 *.order
+*.elf
+*.bin
+*.gz
 
 #
 # Top-level generic files
 #
 tags
 TAGS
-vmlinux*
-!vmlinux.lds.S
-!vmlinux.lds.h
+vmlinux
 System.map
 Module.markers
 Module.symvers
 !.gitignore
+!.mailmap
 
 #
 # Generated include files
-- 
1.5.5.4
