Return-Path: <linux-kernel-owner+w=401wt.eu-S1753875AbYG2AFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbYG2AFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 20:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbYG2AFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 20:05:42 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:65231 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752144AbYG2AFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 20:05:42 -0400
Subject: scripts/mod/modpost.c: fix spelling of module and happens]
Message-Id: <20080729000536.882624806@fluff.org.uk>
User-Agent: quilt/0.46-1
From: Ben Dooks <ben-linux@fluff.org>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Cc: Ben Dooks <ben-linux@fluff.org>
Content-Disposition: inline; filename=simtec/simtec-modpost-spello-fix.patch
Date: Tue, 29 Jul 2008 01:05:37 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Spelling fixes in scripts/mod/modpost.c

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-quilt2/scripts/mod/modpost.c
===================================================================
--- linux-2.6.26-quilt2.orig/scripts/mod/modpost.c	2008-07-15 21:52:19.000000000 +0100
+++ linux-2.6.26-quilt2/scripts/mod/modpost.c	2008-07-15 21:52:40.000000000 +0100
@@ -1468,7 +1468,7 @@ static void section_rel(const char *modn
  * marked __initdata will be discarded when the module has been intialized.
  * Likewise for modules used built-in the sections marked __exit
  * are discarded because __exit marked function are supposed to be called
- * only when a moduel is unloaded which never happes for built-in modules.
+ * only when a module is unloaded which never happens for built-in modules.
  * The check_sec_ref() function traverses all relocation records
  * to find all references to a section that reference a section that will
  * be discarded and warns about it.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
