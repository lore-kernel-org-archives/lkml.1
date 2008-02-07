Return-Path: <linux-kernel-owner+w=401wt.eu-S1765815AbYBGApL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765815AbYBGApL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:45:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932853AbYBGAb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 19:31:59 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:27922 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932462AbYBGAb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 19:31:57 -0500
Date: Wed, 6 Feb 2008 16:29:55 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>, akpm <akpm@linux-foundation.org>,
       willy@linux.intel.com
Subject: [PATCH] docbook: dmapool: fix fatal changed filename
Message-Id: <20080206162955.f7324d02.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Docbook fatal error, file was moved:
docproc: linux-2.6.24-git15/drivers/base/dmapool.c: No such file or directory

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/kernel-api.tmpl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-git15.orig/Documentation/DocBook/kernel-api.tmpl
+++ linux-2.6.24-git15/Documentation/DocBook/kernel-api.tmpl
@@ -165,6 +165,7 @@ X!Ilib/string.c
 !Emm/vmalloc.c
 !Imm/page_alloc.c
 !Emm/mempool.c
+!Emm/dmapool.c
 !Emm/page-writeback.c
 !Emm/truncate.c
      </sect1>
@@ -371,7 +372,6 @@ X!Iinclude/linux/device.h
 !Edrivers/base/class.c
 !Edrivers/base/firmware_class.c
 !Edrivers/base/transport_class.c
-!Edrivers/base/dmapool.c
 <!-- Cannot be included, because
      attribute_container_add_class_device_adapter
  and attribute_container_classdev_to_container
