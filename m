Return-Path: <linux-kernel-owner+w=401wt.eu-S1759243AbZABXQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243AbZABXQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 18:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753015AbZABXQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 18:16:09 -0500
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:17336 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbZABXQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 18:16:08 -0500
Date: Sat, 3 Jan 2009 00:16:03 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: LKML <linux-kernel@vger.kernel.org>
cc: David Mosberger-Tang <davidm@hpl.hp.com>,
       Goutham Rao <goutham.rao@intel.com>,
       Asit Mallick <Asit.K.Mallick@intel.com>, David.Mosberger@acm.org
Subject: [PATCH] Don't include linux/swiotlb.h twice in lib/swiotlb.c
Message-ID: <alpine.LNX.2.00.0901022356121.5463@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There's no point in including the linux/swiotlb.h header twice in 
lib/swiotlb.c - this patch gets rid of the unneeded include.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index fa2dc4e..c3fbcd8 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -23,7 +23,6 @@
 #include <linux/spinlock.h>
 #include <linux/swiotlb.h>
 #include <linux/string.h>
-#include <linux/swiotlb.h>
 #include <linux/types.h>
 #include <linux/ctype.h>
 #include <linux/highmem.h>


-- 
Jesper Juhl <jj@chaosbits.net>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html

