Return-Path: <linux-kernel-owner+w=401wt.eu-S936155AbXGZU3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936155AbXGZU3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 16:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933519AbXGZU3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 16:29:05 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:51324 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933557AbXGZU3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 16:29:03 -0400
Date: Thu, 26 Jul 2007 13:33:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] update dontdiff file
Message-Id: <20070726133345.236936fd.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Updates based on recent .gitignore updates:

*.o.*: Says Alexey Dobriyan:
These are presumably temporary gcc files, which aren't interesting.

setup.bin, setup.elf: new x86 boot code files (from Matthew Wilcox)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/dontdiff |    3 +++
 1 file changed, 3 insertions(+)

--- linux-2623-rc1g2.orig/Documentation/dontdiff
+++ linux-2623-rc1g2/Documentation/dontdiff
@@ -18,6 +18,7 @@
 *.moc
 *.mod.c
 *.o
+*.o.*
 *.orig
 *.out
 *.pdf
@@ -163,6 +164,8 @@ raid6tables.c
 relocs
 series
 setup
+setup.bin
+setup.elf
 sim710_d.h*
 sImage
 sm_tbl*
