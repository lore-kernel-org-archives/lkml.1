Return-Path: <linux-kernel-owner+w=401wt.eu-S1760339AbZGHQK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760339AbZGHQK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759970AbZGHQHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:07:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:60006 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759962AbZGHQHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:07:45 -0400
Subject: [PATCH 43/44] includecheck fix: mm, nommu.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 21:28:17 +0530
Message-Id: <1247068697.4382.109.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  mm/nommu.c: internal.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 mm/nommu.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 53cab10..e1ae0f9 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -56,8 +56,6 @@ void no_printk(const char *fmt, ...)
 	no_printk(KERN_DEBUG FMT"\n", ##__VA_ARGS__)
 #endif
 
-#include "internal.h"
-
 void *high_memory;
 struct page *mem_map;
 unsigned long max_mapnr;
-- 
1.6.0.6



