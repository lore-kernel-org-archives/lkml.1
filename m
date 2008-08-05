Return-Path: <linux-kernel-owner+w=401wt.eu-S1757535AbYHEHJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbYHEHJe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 03:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754429AbYHEGry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 02:47:54 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:44137 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757493AbYHEGrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 02:47:32 -0400
Date: Tue, 5 Aug 2008 00:26:37 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808050626.m756QbSt003788@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc1-git5 26/26] mdb: add Makefile debug directory reference
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Centralized external definitions into include files and corrected 
the file to conform to Linux coding practices.  fixed word wrap
problems with patches.

add the extra directory reference for the /debug directory.

Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/Makefile	2008-08-04 15:53:51.000000000 -0600
+++ b/Makefile	2008-08-04 15:49:51.000000000 -0600
@@ -620,6 +620,7 @@
 
 ifeq ($(KBUILD_EXTMOD),)
 core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/
+core-$(CONFIG_MDB) += debug/
 
 vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, $(init-y) $(init-m) \
 		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \
