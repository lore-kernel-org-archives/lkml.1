Return-Path: <linux-kernel-owner+w=401wt.eu-S1752055AbXH0V1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbXH0V1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756374AbXH0V1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:27:10 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58782 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759338AbXH0V1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:27:07 -0400
Date: Mon, 27 Aug 2007 23:27:03 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, Adam Belay <abelay@novell.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [-mm patch] make "struct menu_governor" static (again)
Message-ID: <20070827212703.GI4121@stusta.de>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070822020648.5ea3a612.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 02:06:48AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.23-rc2-mm2:
>...
>  git-acpi.patch
>...
>  git trees
>...

"struct menu_governor" needlessly again became global.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
cb33b296204127cf50df54b84b2d79e152fb924b 
diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index f5a8865..8d3fdc5 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -117,7 +117,7 @@ static int menu_enable_device(struct cpuidle_device *dev)
 	return 0;
 }
 
-struct cpuidle_governor menu_governor = {
+static struct cpuidle_governor menu_governor = {
 	.name =		"menu",
 	.rating =	20,
 	.enable =	menu_enable_device,

