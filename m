Return-Path: <linux-kernel-owner+w=401wt.eu-S935560AbZLQEEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935560AbZLQEEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:04:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763959AbZLQEEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:04:09 -0500
Received: from kroah.org ([198.145.64.141]:55439 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763962AbZLQEEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:05 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:48 2009
Message-Id: <20091217035648.247081156@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: [041/151] x86: Fix typo in Intel CPU cache size descriptor
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Jones <davej@redhat.com>

commit e02e0e1a130b9ca37c5186d38ad4b3aaf58bb149 upstream.

I double-checked the datasheet. One of the existing
descriptors has a typo: it should be 2MB not 2038 KB.

Signed-off-by: Dave Jones <davej@redhat.com>
LKML-Reference: <20091110200120.GA27090@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/intel_cacheinfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -94,7 +94,7 @@ static const struct _cache_table __cpuin
 	{ 0xd1, LVL_3,    1024 },	/* 4-way set assoc, 64 byte line size */
 	{ 0xd2, LVL_3,    2048 },	/* 4-way set assoc, 64 byte line size */
 	{ 0xd6, LVL_3,    1024 },	/* 8-way set assoc, 64 byte line size */
-	{ 0xd7, LVL_3,    2038 },	/* 8-way set assoc, 64 byte line size */
+	{ 0xd7, LVL_3,    2048 },	/* 8-way set assoc, 64 byte line size */
 	{ 0xd8, LVL_3,    4096 },	/* 12-way set assoc, 64 byte line size */
 	{ 0xdc, LVL_3,    2048 },	/* 12-way set assoc, 64 byte line size */
 	{ 0xdd, LVL_3,    4096 },	/* 12-way set assoc, 64 byte line size */


