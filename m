Return-Path: <linux-kernel-owner+w=401wt.eu-S1759966AbZGHQHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759966AbZGHQHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759259AbZGHQFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:05:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:53261 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759280AbZGHQFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:05:50 -0400
Subject: [PATCH 37/44] includecheck fix: include/linux, aio.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: bcrl@kvack.org, linux-aio@kvack.org, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 21:20:54 +0530
Message-Id: <1247068254.4382.101.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  include/linux/aio.h: linux/aio_abi.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 include/linux/aio.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/aio.h b/include/linux/aio.h
index 47f7d93..aea219d 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -225,8 +225,6 @@ static inline void exit_aio(struct mm_struct *mm) { }
 
 #define io_wait_to_kiocb(wait) container_of(wait, struct kiocb, ki_wait)
 
-#include <linux/aio_abi.h>
-
 static inline struct kiocb *list_kiocb(struct list_head *h)
 {
 	return list_entry(h, struct kiocb, ki_list);
-- 
1.6.0.6



