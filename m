Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbYHUDQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbYHUDQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 23:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755429AbYHUDQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 23:16:06 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:50078 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527AbYHUDQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 23:16:04 -0400
Date: Wed, 20 Aug 2008 20:50:35 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808210250.m7L2oZjl028322@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc4 3/27] mdb: add local Makefile for Merkey's Linux Kernel Debugger module
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add local Makefile for Merkey's Linux Kernel Debugger module


Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/debug/mdb/Makefile	1969-12-31 17:00:00.000000000 -0700
+++ b/debug/mdb/Makefile	2008-08-18 23:40:26.000000000 -0600
@@ -0,0 +1,5 @@
+#
+
+obj-$(CONFIG_MDB) += mdb.o
+
+mdb-y := mdb-main.o mdb-base.o mdb-list.o mdb-logic.o mdb-os.o mdb-ia32.o mdb-ia32-support.o
