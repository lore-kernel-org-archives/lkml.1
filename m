Return-Path: <linux-kernel-owner+w=401wt.eu-S1757668AbZF3VRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668AbZF3VRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 17:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753694AbZF3VRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 17:17:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60856 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271AbZF3VRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 17:17:24 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Fix a warning due to an unnecessary #include of an MTD
	header
To: torvalds@osdl.org, akpm@linux-foundation.org, dwmw2@redhat.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 30 Jun 2009 22:16:51 +0100
Message-ID: <20090630211651.17049.6602.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a warning due to an unnecessary #inclusion of linux/mtd/partitions:

  CC      arch/frv/mb93090-mb00/flash.o
In file included from arch/frv/mb93090-mb00/flash.c:15:
include/linux/mtd/partitions.h:50: warning: 'struct mtd_info' declared inside parameter list
include/linux/mtd/partitions.h:50: warning: its scope is only this definition or declaration, which is probably not what you want
include/linux/mtd/partitions.h:51: warning: 'struct mtd_info' declared inside parameter list
include/linux/mtd/partitions.h:61: warning: 'struct mtd_info' declared inside parameter list
include/linux/mtd/partitions.h:67: warning: 'struct mtd_info' declared inside parameter list

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/mb93090-mb00/flash.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)


diff --git a/arch/frv/mb93090-mb00/flash.c b/arch/frv/mb93090-mb00/flash.c
index c0e3707..6aad117 100644
--- a/arch/frv/mb93090-mb00/flash.c
+++ b/arch/frv/mb93090-mb00/flash.c
@@ -11,7 +11,6 @@
 
 #include <linux/init.h>
 #include <linux/platform_device.h>
-#include <linux/mtd/partitions.h>
 #include <linux/mtd/physmap.h>
 
 #define MB93090_BOOTROM_ADDR	0xFF000000	/* Boot ROM */

