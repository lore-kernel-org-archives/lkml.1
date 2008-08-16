Return-Path: <linux-kernel-owner+w=401wt.eu-S1760959AbYHPEP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760959AbYHPEP4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 00:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756068AbYHPEGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 00:06:22 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:33304 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbYHPEFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 00:05:46 -0400
Date: Fri, 15 Aug 2008 21:41:48 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808160341.m7G3fmZi022578@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc3 28/28] mdb: add /debug directory to main Makefile
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add the /debug directory to the main Makefile for module-based kernel
debuggers.

Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/Makefile	2008-08-15 21:26:10.000000000 -0600
+++ b/Makefile	2008-08-15 15:41:57.000000000 -0600
@@ -620,6 +620,7 @@
 
 ifeq ($(KBUILD_EXTMOD),)
 core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/
+core-$(CONFIG_MDB) += debug/
 
 vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, $(init-y) $(init-m) \
 		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \
