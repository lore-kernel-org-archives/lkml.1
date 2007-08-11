Return-Path: <linux-kernel-owner+w=401wt.eu-S1764581AbXHKVsD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764581AbXHKVsD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 17:48:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761885AbXHKVrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 17:47:51 -0400
Received: from main.gmane.org ([80.91.229.2]:44098 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760775AbXHKVru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 17:47:50 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Steven <hairpinblue@yahoo.com>
Subject: [PATCH] tuxonice-head 070811
Date: Sat, 11 Aug 2007 21:47:40 +0000 (UTC)
Message-ID: <f9lapr$o94$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: rrcs-66-27-48-50.west.biz.rr.com
User-Agent: Pan/0.129 (Benson & Hedges Moscow Gold)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Small problem with kernel/power/tuxonice_checksum.c which causes 
compilation to fail with wrong type for get_next_bit_on

--- tuxonice_checksum.c.orig	2007-08-11 14:22:52.000000000 -0700
+++ tuxonice_checksum.c	2007-08-11 14:23:01.000000000 -0700
@@ -292,7 +292,7 @@
 	if (check)
 		toi_num_resaved = 0;
 
-	BITMAP_FOR_EACH_SET(pageset2_map, pfn) {
+	BITMAP_FOR_EACH_SET(&pageset2_map, pfn) {
 		int ret;
 		if (index % CHECKSUMS_PER_PAGE) {
 			this_checksum += CHECKSUM_SIZE;

