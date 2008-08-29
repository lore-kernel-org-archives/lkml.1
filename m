Return-Path: <linux-kernel-owner+w=401wt.eu-S1753663AbYH2GQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbYH2GQj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 02:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbYH2GP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 02:15:28 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:59509 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbYH2GP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 02:15:26 -0400
Date: Thu, 28 Aug 2008 23:47:41 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808290547.m7T5lfVw016117@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc5 4/29] mdb: add local Makefile for Merkey's Linux Kernel Debugger module
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add local Makefile for Merkey's Linux Kernel Debugger module


Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/debug/mdb/Makefile	1969-12-31 17:00:00.000000000 -0700
+++ b/debug/mdb/Makefile	2008-08-28 14:20:04.000000000 -0600
@@ -0,0 +1,5 @@
+#
+
+obj-$(CONFIG_MDB) += mdb.o
+
+mdb-y := mdb-main.o mdb-base.o mdb-list.o mdb-logic.o mdb-os.o mdb-ia32.o mdb-ia32-support.o mdb-ia32-apic.o
