Return-Path: <linux-kernel-owner+w=401wt.eu-S1759716AbYDUMew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759716AbYDUMew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 08:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758539AbYDUMeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 08:34:24 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:53158 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758262AbYDUMeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 08:34:22 -0400
Message-ID: <480C89CA.8090202@de.ibm.com>
Date: Mon, 21 Apr 2008 14:34:18 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, ltp-list@lists.sourceforge.net,
       ltp-coverage@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, sam@ravnborg.org
Subject: [RFC PATCH 2/8] kbuild: let addtree result in absolute paths only
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
---
 scripts/Kbuild.include |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.25/scripts/Kbuild.include
===================================================================
--- linux-2.6.25.orig/scripts/Kbuild.include
+++ linux-2.6.25/scripts/Kbuild.include
@@ -144,7 +144,7 @@ ld-option = $(call try-run,\
 build := -f $(if $(KBUILD_SRC),$(srctree)/)scripts/Makefile.build obj
 
 # Prefix -I with $(srctree) if it is not an absolute path.
-addtree = $(if $(filter-out -I/%,$(1)),$(patsubst -I%,-I$(srctree)/%,$(1))) $(1)
+addtree = $(if $(filter-out -I/%,$(1)),$(patsubst -I%,-I$(srctree)/%,$(1)),$(1))
 
 # Find all -I options and call addtree
 flags = $(foreach o,$($(1)),$(if $(filter -I%,$(o)),$(call addtree,$(o)),$(o)))







