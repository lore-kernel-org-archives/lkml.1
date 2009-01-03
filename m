Return-Path: <linux-kernel-owner+w=401wt.eu-S1759199AbZACCUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759199AbZACCUo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 21:20:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758728AbZACCUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 21:20:17 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33544 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758580AbZACCUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 21:20:15 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20090103321.351399938@firstfloor.org>
In-Reply-To: <20090103321.351399938@firstfloor.org>
To: linux-kbuild@vger.kernel.org, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [3/3] KBUILD: Add a "bin" symlink for the scripts directory too
Message-Id: <20090103022143.6D0803E6650@basil.firstfloor.org>
Date: Sat,  3 Jan 2009 03:21:43 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Several of the scripts in "scripts" are useful to operate on
files in a separate objdir. Instead of always manually typing
the path to the source dir create a convenient symlink to
the source dir's script directory in the objdir too.

I named it bin because scripts was already used for the object
files of scripts.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 Makefile |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.28-kbuild/Makefile
===================================================================
--- linux-2.6.28-kbuild.orig/Makefile	2009-01-01 15:52:52.000000000 +0100
+++ linux-2.6.28-kbuild/Makefile	2009-01-01 15:53:09.000000000 +0100
@@ -937,6 +937,7 @@
 	    ln -fsn $(srctree)/include/asm-$(SRCARCH) include2/asm;     \
 	fi
 	ln -fsn $(srctree) source
+	ln -fsn $(srctree)/scripts bin
 endif
 
 # prepare2 creates a makefile if using a separate output directory
