Return-Path: <linux-kernel-owner+w=401wt.eu-S1756296AbYJWAQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296AbYJWAQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 20:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbYJWAP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 20:15:59 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:53275 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbYJWAP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 20:15:58 -0400
Message-ID: <48FFC22F.50507@oracle.com>
Date: Wed, 22 Oct 2008 17:15:43 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: akpm <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] block: remove excess kernel-doc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Delete excess kernel-doc notation in block/ subdirectory:

Warning(linux-2.6.27-git10//block/blk-tag.c:164): Excess function parameter or struct member 'tags' description in 'blk_init_tags'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-tag.c |    1 -
 1 file changed, 1 deletion(-)

--- linux-2.6.27-git10.orig/block/blk-tag.c
+++ linux-2.6.27-git10/block/blk-tag.c
@@ -158,7 +158,6 @@ fail:
 /**
  * blk_init_tags - initialize the tag info for an external tag map
  * @depth:	the maximum queue depth supported
- * @tags: the tag to use
  **/
 struct blk_queue_tag *blk_init_tags(int depth)
 {

