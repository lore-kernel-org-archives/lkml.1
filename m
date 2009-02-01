Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872AbZBABM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbZBABM0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 20:12:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbZBABMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 20:12:18 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55643 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744AbZBABMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 20:12:18 -0500
Date: Sat, 31 Jan 2009 20:12:14 -0500
From: Dave Jones <davej@redhat.com>
To: x86@kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Add cache descriptors for Intel Core i7
Message-ID: <20090201011214.GA6043@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, x86@kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Jones <davej@redhat.com>

--- linux-2.6.28.noarch/arch/x86/kernel/cpu/intel_cacheinfo.c~	2009-01-31 20:04:32.000000000 -0500
+++ linux-2.6.28.noarch/arch/x86/kernel/cpu/intel_cacheinfo.c	2009-01-31 20:10:22.000000000 -0500
@@ -36,8 +36,11 @@ static struct _cache_table cache_table[]
 {
 	{ 0x06, LVL_1_INST, 8 },	/* 4-way set assoc, 32 byte line size */
 	{ 0x08, LVL_1_INST, 16 },	/* 4-way set assoc, 32 byte line size */
+	{ 0x09, LVL_1_INST, 32 },	/* 4-way set assoc, 64 byte line size */
 	{ 0x0a, LVL_1_DATA, 8 },	/* 2 way set assoc, 32 byte line size */
 	{ 0x0c, LVL_1_DATA, 16 },	/* 4-way set assoc, 32 byte line size */
+	{ 0x0d, LVL_1_DATA, 16 },	/* 4-way set assoc, 64 byte line size */
+	{ 0x21, LVL_2,      256 },	/* 8-way set assoc, 64 byte line size */
 	{ 0x22, LVL_3,      512 },	/* 4-way set assoc, sectored cache, 64 byte line size */
 	{ 0x23, LVL_3,      1024 },	/* 8-way set assoc, sectored cache, 64 byte line size */
 	{ 0x25, LVL_3,      2048 },	/* 8-way set assoc, sectored cache, 64 byte line size */
@@ -85,6 +88,18 @@ static struct _cache_table cache_table[]
 	{ 0x85, LVL_2,    2048 },	/* 8-way set assoc, 32 byte line size */
 	{ 0x86, LVL_2,     512 },	/* 4-way set assoc, 64 byte line size */
 	{ 0x87, LVL_2,    1024 },	/* 8-way set assoc, 64 byte line size */
+	{ 0xd0, LVL_3,     512 },	/* 4-way set assoc, 64 byte line size */
+	{ 0xd1, LVL_3,    1024 },	/* 4-way set assoc, 64 byte line size */
+	{ 0xd2, LVL_3,    2048 },	/* 4-way set assoc, 64 byte line size */
+	{ 0xd6, LVL_3,    1024 },	/* 8-way set assoc, 64 byte line size */
+	{ 0xd7, LVL_3,    2038 },	/* 8-way set assoc, 64 byte line size */
+	{ 0xd8, LVL_3,    4096 },	/* 12-way set assoc, 64 byte line size */
+	{ 0xdc, LVL_3,    2048 },	/* 12-way set assoc, 64 byte line size */
+	{ 0xdd, LVL_3,    4096 },	/* 12-way set assoc, 64 byte line size */
+	{ 0xde, LVL_3,    8192 },	/* 12-way set assoc, 64 byte line size */
+	{ 0xe2, LVL_3,    2048 },	/* 16-way set assoc, 64 byte line size */
+	{ 0xe3, LVL_3,    4096 },	/* 16-way set assoc, 64 byte line size */
+	{ 0xe4, LVL_3,    8192 },	/* 16-way set assoc, 64 byte line size */
 	{ 0x00, 0, 0}
 };
 

-- 
http://www.codemonkey.org.uk
