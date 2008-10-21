Return-Path: <linux-kernel-owner+w=401wt.eu-S1754726AbYJUR3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbYJUR3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 13:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751587AbYJUR3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 13:29:34 -0400
Received: from relay2.sgi.com ([192.48.171.30]:42490 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751232AbYJUR3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 13:29:33 -0400
Date: Tue, 21 Oct 2008 12:29:32 -0500
From: Dean Nelson <dcn@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sgi-xp: only build for ia64-sn2 when CONFIG_IA64_GENERIC specified
Message-ID: <20081021172932.GA12028@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the time being build for ia64-sn2 alone when CONFIG_IA64_GENERIC is
specified.

Signed-off-by: Dean Nelson <dcn@sgi.com>

---

 drivers/misc/sgi-xp/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/drivers/misc/sgi-xp/Makefile
===================================================================
--- linux.orig/drivers/misc/sgi-xp/Makefile	2008-10-21 07:54:30.000000000 -0500
+++ linux/drivers/misc/sgi-xp/Makefile	2008-10-21 12:19:48.000000000 -0500
@@ -5,14 +5,14 @@
 obj-$(CONFIG_SGI_XP)		+= xp.o
 xp-y				:= xp_main.o
 xp-$(CONFIG_IA64_SGI_SN2)	+= xp_sn2.o xp_nofault.o
-xp-$(CONFIG_IA64_GENERIC)	+= xp_sn2.o xp_nofault.o xp_uv.o
+xp-$(CONFIG_IA64_GENERIC)	+= xp_sn2.o xp_nofault.o
 xp-$(CONFIG_IA64_SGI_UV)	+= xp_uv.o
 xp-$(CONFIG_X86_64)		+= xp_uv.o
 
 obj-$(CONFIG_SGI_XP)		+= xpc.o
 xpc-y				:= xpc_main.o xpc_channel.o xpc_partition.o
 xpc-$(CONFIG_IA64_SGI_SN2)	+= xpc_sn2.o
-xpc-$(CONFIG_IA64_GENERIC)	+= xpc_sn2.o xpc_uv.o
+xpc-$(CONFIG_IA64_GENERIC)	+= xpc_sn2.o
 xpc-$(CONFIG_IA64_SGI_UV) 	+= xpc_uv.o
 xpc-$(CONFIG_X86_64)		+= xpc_uv.o
 
