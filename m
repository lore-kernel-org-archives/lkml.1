Return-Path: <linux-kernel-owner+w=401wt.eu-S1755938AbXFLXE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbXFLXE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 19:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755522AbXFLXDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 19:03:17 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33088 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754005AbXFLXDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 19:03:11 -0400
Date: Wed, 13 Jun 2007 01:03:23 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, lenb@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [-mm patch] drivers/cpuidle/governors/menu.c: make a struct static
Message-ID: <20070612230323.GE3588@stusta.de>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 10:03:13PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc4-mm1:
> 
>  git-acpi.patch
>...
>  git trees
>...

This patch makes the needlessly global struct menu_governor static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc4-mm2/drivers/cpuidle/governors/menu.c.old	2007-06-13 00:25:03.000000000 +0200
+++ linux-2.6.22-rc4-mm2/drivers/cpuidle/governors/menu.c	2007-06-13 00:25:13.000000000 +0200
@@ -123,7 +123,7 @@
 	data->deepest_bm_state = i - 1;
 }
 
-struct cpuidle_governor menu_governor = {
+static struct cpuidle_governor menu_governor = {
 	.name =		"menu",
 	.scan =		menu_scan_device,
 	.select =	menu_select,

