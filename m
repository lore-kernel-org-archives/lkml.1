Return-Path: <linux-kernel-owner+w=401wt.eu-S1759593AbXGIR6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593AbXGIR6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 13:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754469AbXGIR6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 13:58:24 -0400
Received: from xenotime.net ([66.160.160.81]:34616 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754710AbXGIR6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 13:58:23 -0400
Date: Mon, 9 Jul 2007 11:01:51 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] docbook: don't reference file without kernel-doc
Message-Id: <20070709110151.1189b7fc.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Remove include/linux/rmap.h from kernel-api.tmpl since it no longer
contains kernel-doc.  Fixes this warning:

Warning(linux-2.6.22//include/linux/rmap.h): no structured comments found

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/kernel-api.tmpl |    1 -
 1 file changed, 1 deletion(-)

--- linux-2.6.22.orig/Documentation/DocBook/kernel-api.tmpl
+++ linux-2.6.22/Documentation/DocBook/kernel-api.tmpl
@@ -157,7 +157,6 @@ X!Ilib/string.c
 !Earch/i386/lib/usercopy.c
      </sect1>
      <sect1><title>More Memory Management Functions</title>
-!Iinclude/linux/rmap.h
 !Emm/readahead.c
 !Emm/filemap.c
 !Emm/memory.c
