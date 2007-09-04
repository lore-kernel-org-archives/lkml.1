Return-Path: <linux-kernel-owner+w=401wt.eu-S1753220AbXIDHYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbXIDHYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 03:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751679AbXIDHYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 03:24:00 -0400
Received: from mo32.po.2iij.NET ([210.128.50.17]:7978 "EHLO mo32.po.2iij.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbXIDHX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 03:23:59 -0400
Date: Tue, 4 Sep 2007 16:23:45 +0900
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
To: rpurdie@rpsys.net
Cc: yoichi_yuasa@tripeaks.co.jp, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] leds: add #include <linux/spinlock_types.h> to
 include/linux/leds.h for rwlock_t
Message-Id: <20070904162345.30e82bc8.yoichi_yuasa@tripeaks.co.jp>
Organization: TriPeaks Corporation
X-Mailer: Sylpheed version 1.0.4 (GTK+ 1.2.10; i386-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch has added #include <linux/spinlock_types.h> to include/linux/leds.h for rwlock_t.

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

diff -pruN -X generic/Documentation/dontdiff generic-orig/include/linux/leds.h generic/include/linux/leds.h
--- generic-orig/include/linux/leds.h	2007-09-04 14:59:51.334686250 +0900
+++ generic/include/linux/leds.h	2007-09-04 14:56:10.676896000 +0900
@@ -13,6 +13,7 @@
 #define __LINUX_LEDS_H_INCLUDED
 
 #include <linux/list.h>
+#include <linux/spinlock_types.h>
 
 struct device;
 /*

