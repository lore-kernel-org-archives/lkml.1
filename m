Return-Path: <linux-kernel-owner+w=401wt.eu-S935028AbXGaWD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935028AbXGaWD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 18:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759084AbXGaWDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 18:03:45 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2444 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758305AbXGaWDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 18:03:44 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 71] kernel/sched.c: kmalloc + memset conversion to kcalloc
Date: Wed, 1 Aug 2007 00:03:44 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       gregkh@suse.de
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708010003.45279.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 kernel/sched.c | 166559 -> 166517 (-42 bytes)
 kernel/sched.o | 445965 -> 445941 (-24 bytes)

 kernel/sched.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.23-rc1-mm1-a/kernel/sched.c	2007-07-26 13:07:44.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/kernel/sched.c	2007-07-31 15:10:55.000000000 +0200
@@ -5167,10 +5167,10 @@ static struct ctl_table sd_ctl_root[] =

 static struct ctl_table *sd_alloc_ctl_entry(int n)
 {
-	struct ctl_table *entry =
-		kmalloc(n * sizeof(struct ctl_table), GFP_KERNEL);
+	struct ctl_table *entry;
+
+	entry = kcalloc(n, sizeof(struct ctl_table), GFP_KERNEL);
 	BUG_ON(!entry);
-	memset(entry, 0, n * sizeof(struct ctl_table));
 	return entry;
 }

