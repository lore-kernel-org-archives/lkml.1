Return-Path: <linux-kernel-owner+w=401wt.eu-S1759546AbXLTXsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759546AbXLTXsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 18:48:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755822AbXLTXrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 18:47:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:53926 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424AbXLTXrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 18:47:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,191,1196668800"; 
   d="scan'208";a="302140799"
From: Jason Gaston <jason.d.gaston@intel.com>
To: jason.d.gaston@intel.com, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: [PATCH 2.6.24-rc5] x86 intel_cacheinfo.c: cpu cache info entry for Intel Tolapai
Date: Thu, 20 Dec 2007 16:50:53 -0800
User-Agent: KMail/1.9.1
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712201650.53893.jason.d.gaston@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a cpu cache info entry for the Intel Tolapai cpu.

Signed-off-by:  Jason Gaston <jason.d.gaston@intel.com>

--- linux-2.6.24-rc5/arch/x86/kernel/cpu/intel_cacheinfo.c.orig	2007-12-20 16:33:33.000000000 -0800
+++ linux-2.6.24-rc5/arch/x86/kernel/cpu/intel_cacheinfo.c	2007-12-20 16:34:22.000000000 -0800
@@ -49,6 +49,7 @@
 	{ 0x3c, LVL_2,      256 },	/* 4-way set assoc, sectored cache, 64 byte line size */
 	{ 0x3d, LVL_2,      384 },	/* 6-way set assoc, sectored cache, 64 byte line size */
 	{ 0x3e, LVL_2,      512 },	/* 4-way set assoc, sectored cache, 64 byte line size */
+	{ 0x3f, LVL_2,      256 },	/* 2-way set assoc, 64 byte line size */
 	{ 0x41, LVL_2,      128 },	/* 4-way set assoc, 32 byte line size */
 	{ 0x42, LVL_2,      256 },	/* 4-way set assoc, 32 byte line size */
 	{ 0x43, LVL_2,      512 },	/* 4-way set assoc, 32 byte line size */
