Return-Path: <linux-kernel-owner+w=401wt.eu-S936115AbZLQBnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936115AbZLQBnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:43:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758376AbZLQBl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:41:59 -0500
Received: from kroah.org ([198.145.64.141]:47852 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763601AbZLQBUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:08 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:01 2009
Message-Id: <20091217011601.389918723@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:14:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: [27/90] x86: Add new Intel CPU cache size descriptors
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Jones <davej@redhat.com>

commit 85160b92fbd35321104819283c91bfed2b553e3c upstream.

The latest rev of Intel doc AP-485 details new cache descriptors
that we don't yet support. 12MB, 18MB and 24MB 24-way assoc L3
caches.

Signed-off-by: Dave Jones <davej@redhat.com>
LKML-Reference: <20091110184924.GA20337@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/intel_cacheinfo.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -101,6 +101,9 @@ static const struct _cache_table __cpuin
 	{ 0xe2, LVL_3,    2048 },	/* 16-way set assoc, 64 byte line size */
 	{ 0xe3, LVL_3,    4096 },	/* 16-way set assoc, 64 byte line size */
 	{ 0xe4, LVL_3,    8192 },	/* 16-way set assoc, 64 byte line size */
+	{ 0xea, LVL_3,    12288 },	/* 24-way set assoc, 64 byte line size */
+	{ 0xeb, LVL_3,    18432 },	/* 24-way set assoc, 64 byte line size */
+	{ 0xec, LVL_3,    24576 },	/* 24-way set assoc, 64 byte line size */
 	{ 0x00, 0, 0}
 };
 


