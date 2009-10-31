Return-Path: <linux-kernel-owner+w=401wt.eu-S933336AbZJaVpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933336AbZJaVpQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 17:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933326AbZJaVpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 17:45:03 -0400
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:1075 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933282AbZJaVoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 17:44:54 -0400
From: Alberto Bertogli <albertito@blitiri.com.ar>
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org, trivial@kernel.org,
       Alberto Bertogli <albertito@blitiri.com.ar>
Subject: [PATCH] bio_put(): add bio_clone() to the list of functions in the comment
Date: Sat, 31 Oct 2009 18:18:52 -0300
Message-Id: <1257023932-22868-1-git-send-email-albertito@blitiri.com.ar>
X-Mailer: git-send-email 1.6.5.2.250.g2bd30
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
index 402cb84..bcab9e9 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -407,7 +407,7 @@ EXPORT_SYMBOL(zero_fill_bio);
  *
  * Description:
  *   Put a reference to a &struct bio, either one you have gotten with
- *   bio_alloc or bio_get. The last put of a bio will free it.
+ *   bio_alloc, bio_get or bio_clone. The last put of a bio will free it.
  **/
 void bio_put(struct bio *bio)
 {
-- 
1.6.5.2.250.g2bd30

