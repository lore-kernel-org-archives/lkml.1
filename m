Return-Path: <linux-kernel-owner+w=401wt.eu-S1758009AbZKJUBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009AbZKJUBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 15:01:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757941AbZKJUBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 15:01:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757925AbZKJUBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 15:01:53 -0500
Date: Tue, 10 Nov 2009 15:01:20 -0500
From: Dave Jones <davej@redhat.com>
To: x86@kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Fix typo in intel cache size
Message-ID: <20091110200120.GA27090@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, x86@kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I double-checked the datasheet. This should be 2MB.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 804c40e..6123138 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -94,7 +94,7 @@ static const struct _cache_table __cpuinitconst cache_table[] =
 	{ 0xd1, LVL_3,    1024 },	/* 4-way set assoc, 64 byte line size */
 	{ 0xd2, LVL_3,    2048 },	/* 4-way set assoc, 64 byte line size */
 	{ 0xd6, LVL_3,    1024 },	/* 8-way set assoc, 64 byte line size */
-	{ 0xd7, LVL_3,    2038 },	/* 8-way set assoc, 64 byte line size */
+	{ 0xd7, LVL_3,    2048 },	/* 8-way set assoc, 64 byte line size */
 	{ 0xd8, LVL_3,    4096 },	/* 12-way set assoc, 64 byte line size */
 	{ 0xdc, LVL_3,    2048 },	/* 12-way set assoc, 64 byte line size */
 	{ 0xdd, LVL_3,    4096 },	/* 12-way set assoc, 64 byte line size */
