Return-Path: <linux-kernel-owner+w=401wt.eu-S1760487AbZBDSuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760487AbZBDSuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:50:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760801AbZBDSqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:46:40 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:43377 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758801AbZBDSqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:46:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=GtfZruL9IwLU8y92vPwfOp/GzPk6nX472OInj9kHEvJoHe8OuYyPhFp43yphI85xQ0
         9YmDYNZcH9CPMOdf0MEBSV9LA1h8dntZni/8MTUFJ0eZu+8C0mUZ0ELUQxJXOyrEphG/
         AfxIgbC0xAy6Bz83MENJfOoFVNRYMCsULqYPY=
From: Alberto Bertogli <albertito@blitiri.com.ar>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Alberto Bertogli <albertito@blitiri.com.ar>
Subject: [PATCH] bio_put(): add bio_clone() to the list of functions in the comment
Date: Wed,  4 Feb 2009 16:46:25 -0200
Message-Id: <1233773185-13135-1-git-send-email-albertito@blitiri.com.ar>
X-Mailer: git-send-email 1.6.1.1.363.g2a3bd
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
index 4fb5046..43038f9 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -392,7 +392,7 @@ EXPORT_SYMBOL(zero_fill_bio);
  *
  * Description:
  *   Put a reference to a &struct bio, either one you have gotten with
- *   bio_alloc or bio_get. The last put of a bio will free it.
+ *   bio_alloc, bio_get or bio_clone. The last put of a bio will free it.
  **/
 void bio_put(struct bio *bio)
 {
-- 
1.6.1.1.363.g2a3bd

