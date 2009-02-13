Return-Path: <linux-kernel-owner+w=401wt.eu-S1756379AbZBMJdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbZBMJdP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 04:33:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbZBMJc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 04:32:58 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56515 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbZBMJc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 04:32:57 -0500
Message-ID: <49953E90.8030306@cn.fujitsu.com>
Date: Fri, 13 Feb 2009 17:34:08 +0800
From: Yang Hongyang <yanghy@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: linux-fbdev-devel@lists.sourceforge.net
CC: rjw@sisk.pl, linux-kernel@vger.kernel.org, rui.zhang@intel.com
Subject: [PATCH]atyfb:remove  unused variable =?windows-1252?Q?=91pwr=5Fc?=
 =?windows-1252?Q?ommand=92?=
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove  unused variable ‘pwr_command’ 

Signed-off-by: Yang Hongyang<yanghy@cn.fujitsu.com>

---
 drivers/video/aty/aty128fb.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/video/aty/aty128fb.c b/drivers/video/aty/aty128fb.c
index e6e299f..2181ce4 100644
--- a/drivers/video/aty/aty128fb.c
+++ b/drivers/video/aty/aty128fb.c
@@ -2365,7 +2365,6 @@ static void fbcon_aty128_bmove(struct display *p, int sy, int sx, int dy, int dx
 static void aty128_set_suspend(struct aty128fb_par *par, int suspend)
 {
 	u32	pmgt;
-	u16	pwr_command;
 	struct pci_dev *pdev = par->pdev;
 
 	if (!par->pm_reg)
-- 
1.6.0.3

-- 
Regards
Yang Hongyang
