Return-Path: <linux-kernel-owner+w=401wt.eu-S933552AbXCTOvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933552AbXCTOvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 10:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933559AbXCTOvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 10:51:51 -0400
Received: from ozlabs.org ([203.10.76.45]:54857 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933552AbXCTOvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 10:51:51 -0400
Date: Tue, 20 Mar 2007 09:47:47 -0500
From: Anton Blanchard <anton@samba.org>
To: sam@ravnborg.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] small documentation fix in Documentation/kbuild/modules.txt
Message-ID: <20070320144747.GF31173@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The Makefile fragment in Documentation/kbuild/modules.txt looks to be 
missing some braces.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

diff --git a/Documentation/kbuild/modules.txt b/Documentation/kbuild/modules.txt
index 769ee05..1d247d5 100644
--- a/Documentation/kbuild/modules.txt
+++ b/Documentation/kbuild/modules.txt
@@ -249,7 +249,7 @@ following files:
 		--> filename: Makefile
 		KERNELDIR := /lib/modules/`uname -r`/build
 		all::
-			$(MAKE) -C $KERNELDIR M=`pwd` $@
+			$(MAKE) -C $(KERNELDIR) M=`pwd` $@
 
 		# Module specific targets
 		genbin:
