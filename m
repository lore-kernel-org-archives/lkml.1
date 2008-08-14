Return-Path: <linux-kernel-owner+w=401wt.eu-S1754763AbYHNGiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbYHNGiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 02:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbYHNGhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 02:37:55 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:38117 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbYHNGhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 02:37:54 -0400
Date: Thu, 14 Aug 2008 00:14:37 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808140614.m7E6Ebw4006233@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc3 3/29] mdb: add mdb kernel debugger Makefile
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add the makefile for the MDB kernel debugger 

Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/debug/mdb/Makefile	1969-12-31 17:00:00.000000000 -0700
+++ b/debug/mdb/Makefile	2008-08-13 11:56:03.000000000 -0600
@@ -0,0 +1,5 @@
+#
+
+obj-$(CONFIG_MDB) += mdb.o
+
+mdb-y := mdb-main.o mdb-base.o mdb-list.o mdb-logic.o mdb-os.o mdb-ia32.o mdb-ia32-support.o
