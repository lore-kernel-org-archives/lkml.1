Return-Path: <linux-kernel-owner+w=401wt.eu-S1760857AbYFQWdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760857AbYFQWdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 18:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760039AbYFQWbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 18:31:45 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:49590 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759971AbYFQWbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 18:31:44 -0400
Date: Wed, 18 Jun 2008 01:30:17 +0300
From: Adrian Bunk <bunk@kernel.org>
To: adaplas@gmail.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] video/stifb.c: make 2 functions static
Message-ID: <20080617223017.GG25911@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following needlessly global functions static:
- stifb_init_fb()
- stifb_init()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/video/stifb.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

952f8b344428d8995c34a677a9672656e0a306d6 diff --git a/drivers/video/stifb.c b/drivers/video/stifb.c
index 598d35e..1664814 100644
--- a/drivers/video/stifb.c
+++ b/drivers/video/stifb.c
@@ -1078,8 +1078,7 @@ static struct fb_ops stifb_ops = {
  *  Initialization
  */
 
-int __init
-stifb_init_fb(struct sti_struct *sti, int bpp_pref)
+static int __init stifb_init_fb(struct sti_struct *sti, int bpp_pref)
 {
 	struct fb_fix_screeninfo *fix;
 	struct fb_var_screeninfo *var;
@@ -1315,8 +1314,7 @@ static int stifb_disabled __initdata;
 int __init
 stifb_setup(char *options);
 
-int __init
-stifb_init(void)
+static int __init stifb_init(void)
 {
 	struct sti_struct *sti;
 	struct sti_struct *def_sti;

