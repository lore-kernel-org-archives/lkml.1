Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbYHNGii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbYHNGii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 02:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbYHNGhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 02:37:55 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:38115 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbYHNGhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 02:37:54 -0400
Date: Thu, 14 Aug 2008 00:14:37 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808140614.m7E6EbId006231@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc3 2/29] mdb: add debug directory Makefile
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add a debug directory makefile for loadable kernel debugger modules.

Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/debug/Makefile	1969-12-31 17:00:00.000000000 -0700
+++ b/debug/Makefile	2008-08-13 11:56:03.000000000 -0600
@@ -0,0 +1,5 @@
+#
+# Makefile for kernel debugger modules
+#
+
+obj-$(CONFIG_MDB)		+= mdb/
