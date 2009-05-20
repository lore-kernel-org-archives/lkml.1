Return-Path: <linux-kernel-owner+w=401wt.eu-S1756735AbZETT7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735AbZETT7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 15:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755860AbZETT7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 15:59:03 -0400
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:3716 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbZETT7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 15:59:01 -0400
From: Alberto Bertogli <albertito@blitiri.com.ar>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       Alberto Bertogli <albertito@blitiri.com.ar>
Subject: [PATCH 2/4] bio_put(): add bio_clone() to the list of functions in the comment
Date: Wed, 20 May 2009 16:03:55 -0300
Message-Id: <1242846235-1302-1-git-send-email-albertito@blitiri.com.ar>
X-Mailer: git-send-email 1.6.2.2.646.gb214
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In bio_put()'s comment, add bio_clone() to the list of functions that can
give you a bio reference.

Signed-off-by: Alberto Bertogli <albertito@blitiri.com.ar>
---
 fs/bio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 9871164..48286e4 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -404,7 +404,7 @@ EXPORT_SYMBOL(zero_fill_bio);
  *
  * Description:
  *   Put a reference to a &struct bio, either one you have gotten with
- *   bio_alloc or bio_get. The last put of a bio will free it.
+ *   bio_alloc, bio_get or bio_clone. The last put of a bio will free it.
  **/
 void bio_put(struct bio *bio)
 {
-- 
1.6.2.2.646.gb214

