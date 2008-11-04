Return-Path: <linux-kernel-owner+w=401wt.eu-S1754309AbYKDKgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309AbYKDKgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 05:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbYKDKgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 05:36:08 -0500
Received: from smtp.zeuux.org ([210.51.160.52]:53985 "EHLO z.billxu.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238AbYKDKgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 05:36:07 -0500
Date: Tue, 4 Nov 2008 18:35:57 +0800
From: Jianjun Kong <jianjun@zeuux.org>
To: dwmw2@infradead.org
Cc: Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
Subject: [PATCH] fs: remove duplicated #include
Message-ID: <20081104103557.GA6854@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[PATCH] fs: remove duplicated #include

Removed duplicated #include <linux/errno.h> in fs/jffs2/compr_rubin.c

Signed-off-by: Jianjun Kong <jianjun@zeuux.org>
---
 fs/jffs2/compr_rubin.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/jffs2/compr_rubin.c b/fs/jffs2/compr_rubin.c
index c73fa89..2bc0fe4 100644
--- a/fs/jffs2/compr_rubin.c
+++ b/fs/jffs2/compr_rubin.c
@@ -24,7 +24,6 @@
 #define BIT_DIVIDER_MIPS 1043
 static int bits_mips[8] = { 277,249,290,267,229,341,212,241}; /* mips32 */
 
-#include <linux/errno.h>
 
 struct pushpull {
 	unsigned char *buf;
-- 
1.5.6.3

