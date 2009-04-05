Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676AbZDEWrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbZDEWrI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 18:47:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbZDEWqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 18:46:54 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:63670 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbZDEWqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 18:46:53 -0400
Message-ID: <49D9348E.90305@oracle.com>
Date: Sun, 05 Apr 2009 15:45:34 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] docbook: fix fatal filename error
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.49D93491.00BC:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix docbook fatal error:

docproc: block/blktrace.c: No such file or directory

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/kernel-api.tmpl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-2.6.orig/Documentation/DocBook/kernel-api.tmpl
+++ lnx-2.6/Documentation/DocBook/kernel-api.tmpl
@@ -259,7 +259,7 @@ X!Earch/x86/kernel/mca_32.c
 !Eblock/blk-tag.c
 !Iblock/blk-tag.c
 !Eblock/blk-integrity.c
-!Iblock/blktrace.c
+!Ikernel/trace/blktrace.c
 !Iblock/genhd.c
 !Eblock/genhd.c
   </chapter>
