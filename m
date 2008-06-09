Return-Path: <linux-kernel-owner+w=401wt.eu-S1761694AbYFIW3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761694AbYFIW3b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761163AbYFIW1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:27:18 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54199 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761608AbYFIW1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:27:18 -0400
Date: Tue, 10 Jun 2008 01:26:24 +0300
From: Adrian Bunk <bunk@kernel.org>
To: adaplas@gmail.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] make macfb_setup() static
Message-ID: <20080609222623.GV1987@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global macfb_setup() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
aa311d90b78850adac704e0fb056b77e5eec4bfe diff --git a/drivers/video/macfb.c b/drivers/video/macfb.c
index aa8c714..b790ddf 100644
--- a/drivers/video/macfb.c
+++ b/drivers/video/macfb.c
@@ -596,7 +596,7 @@ static struct fb_ops macfb_ops = {
 	.fb_imageblit	= cfb_imageblit,
 };
 
-void __init macfb_setup(char *options)
+static void __init macfb_setup(char *options)
 {
 	char *this_opt;
 	

