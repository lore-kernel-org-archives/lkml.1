Return-Path: <linux-kernel-owner+w=401wt.eu-S1754943AbYCIX4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbYCIX4O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 19:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbYCIXz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 19:55:59 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:4356 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbYCIXz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 19:55:59 -0400
Subject: [PATCH] include/linux/aio.h - remove duplicate includes
From: Joe Perches <joe@perches.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: linux-aio@kvack.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 09 Mar 2008 16:54:54 -0700
Message-Id: <1205106894.656.97.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>

 include/linux/aio.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/include/linux/aio.h b/include/linux/aio.h
index 0d0b7f6..525dbb7 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -7,7 +7,6 @@
 #include <linux/uio.h>
 
 #include <asm/atomic.h>
-#include <linux/uio.h>
 
 #define AIO_MAXSEGS		4
 #define AIO_KIOGRP_NR_ATOMIC	8
@@ -233,8 +232,6 @@ int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 
 #define io_wait_to_kiocb(wait) container_of(wait, struct kiocb, ki_wait)
 
-#include <linux/aio_abi.h>
-
 static inline struct kiocb *list_kiocb(struct list_head *h)
 {
 	return list_entry(h, struct kiocb, ki_list);


