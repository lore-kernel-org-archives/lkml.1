Return-Path: <linux-kernel-owner+w=401wt.eu-S1762931AbYEEVxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762931AbYEEVxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 17:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759929AbYEEVxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 17:53:07 -0400
Received: from testure.choralone.org ([194.9.77.134]:60411 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756495AbYEEVxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 17:53:06 -0400
Date: Mon, 5 May 2008 17:52:52 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [X86] Add new cache descriptor.
Message-ID: <20080505215252.GA31722@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest rev of Intel doc AP-485 details a new cache
descriptor that we don't yet support.
A 6MB 24-way assoc L2 cache.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 26d615d..2c8afaf 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -62,6 +62,7 @@ static struct _cache_table cache_table[] __cpuinitdata =
 	{ 0x4b, LVL_3,      8192 },	/* 16-way set assoc, 64 byte line size */
 	{ 0x4c, LVL_3,     12288 },	/* 12-way set assoc, 64 byte line size */
 	{ 0x4d, LVL_3,     16384 },	/* 16-way set assoc, 64 byte line size */
+	{ 0x4e, LVL_2,      6144 },	/* 24-way set assoc, 64 byte line size */
 	{ 0x60, LVL_1_DATA, 16 },	/* 8-way set assoc, sectored cache, 64 byte line size */
 	{ 0x66, LVL_1_DATA, 8 },	/* 4-way set assoc, sectored cache, 64 byte line size */
 	{ 0x67, LVL_1_DATA, 16 },	/* 4-way set assoc, sectored cache, 64 byte line size */

-- 
http://www.codemonkey.org.uk
