Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbYHUDXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbYHUDXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 23:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756876AbYHUDQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 23:16:41 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:50121 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955AbYHUDQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 23:16:10 -0400
Date: Wed, 20 Aug 2008 20:50:37 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808210250.m7L2obY3028352@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc4 27/27] mdb: add /debug directory to main Makefile 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add /debug directory to main Makefile 

Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/Makefile	2008-08-19 14:10:42.000000000 -0600
+++ b/Makefile	2008-08-19 14:09:39.000000000 -0600
@@ -620,6 +620,7 @@
 
 ifeq ($(KBUILD_EXTMOD),)
 core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/
+core-$(CONFIG_MDB) += debug/
 
 vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, $(init-y) $(init-m) \
 		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \
