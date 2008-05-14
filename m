Return-Path: <linux-kernel-owner+w=401wt.eu-S932143AbYENS0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbYENS0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 14:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755090AbYENS0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 14:26:06 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:33991 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776AbYENS0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 14:26:05 -0400
Date: Wed, 14 May 2008 14:25:58 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH]  Remove final references to deprecated, unreferenced
 TOPDIR.
Message-ID: <alpine.LFD.1.10.0805141424470.21882@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now that the final references to the deprecated TOPDIR are gone, it
seems safe to remove its definition.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

diff --git a/Makefile b/Makefile
index 3140145..2f2bf3e 100644
--- a/Makefile
+++ b/Makefile
@@ -148,15 +148,13 @@ _all: modules
 endif

 srctree		:= $(if $(KBUILD_SRC),$(KBUILD_SRC),$(CURDIR))
-TOPDIR		:= $(srctree)
-# FIXME - TOPDIR is obsolete, use srctree/objtree
 objtree		:= $(CURDIR)
 src		:= $(srctree)
 obj		:= $(objtree)

 VPATH		:= $(srctree)$(if $(KBUILD_EXTMOD),:$(KBUILD_EXTMOD))

-export srctree objtree VPATH TOPDIR
+export srctree objtree VPATH


 # SUBARCH tells the usermode build what the underlying arch is.  That is set

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
