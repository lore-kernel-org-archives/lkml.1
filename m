Return-Path: <linux-kernel-owner+w=401wt.eu-S1757543AbZKJSto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbZKJSto (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 13:49:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755225AbZKJSto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 13:49:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbZKJStn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 13:49:43 -0500
Date: Tue, 10 Nov 2009 13:49:24 -0500
From: Dave Jones <davej@redhat.com>
To: x86@kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: x86: add new cache descriptors
Message-ID: <20091110184924.GA20337@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, x86@kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest rev of Intel doc AP-485 details new cache descriptors that we don't yet support.
12MB, 18MB and 24MB 24-way assoc L3 caches.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 804c40e..228fc67 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -102,6 +102,9 @@ static const struct _cache_table __cpuinitconst cache_table[] =
 	{ 0xe2, LVL_3,    2048 },	/* 16-way set assoc, 64 byte line size */
 	{ 0xe3, LVL_3,    4096 },	/* 16-way set assoc, 64 byte line size */
 	{ 0xe4, LVL_3,    8192 },	/* 16-way set assoc, 64 byte line size */
+	{ 0xea, LVL_3,    12288 },	/* 24-way set assoc, 64 byte line size */
+	{ 0xeb, LVL_3,    18432 },	/* 24-way set assoc, 64 byte line size */
+	{ 0xec, LVL_3,    24576 },	/* 24-way set assoc, 64 byte line size */
 	{ 0x00, 0, 0}
 };
 
