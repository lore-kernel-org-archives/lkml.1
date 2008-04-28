Return-Path: <linux-kernel-owner+w=401wt.eu-S934969AbYD1RVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934969AbYD1RVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 13:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934421AbYD1RVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 13:21:42 -0400
Received: from xenotime.net ([66.160.160.81]:42116 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933982AbYD1RVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 13:21:42 -0400
Date: Mon, 28 Apr 2008 10:21:40 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] docbook: fix bitops fatal filename error
Message-ID: <Pine.LNX.4.64.0804281019510.30172@shark.he.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

bitops source file was renamed, so fix docbook for that.
docproc: linux-2.6.25-git11/include/asm-x86/bitops_32.h: No such file or directory

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/kernel-api.tmpl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.25-git11.orig/Documentation/DocBook/kernel-api.tmpl
+++ linux-2.6.25-git11/Documentation/DocBook/kernel-api.tmpl
@@ -119,7 +119,7 @@ X!Ilib/string.c
 !Elib/string.c
      </sect1>
      <sect1><title>Bit Operations</title>
-!Iinclude/asm-x86/bitops_32.h
+!Iinclude/asm-x86/bitops.h
      </sect1>
   </chapter>
 
