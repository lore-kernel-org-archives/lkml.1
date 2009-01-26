Return-Path: <linux-kernel-owner+w=401wt.eu-S1751598AbZAZBhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbZAZBhw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 20:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbZAZBhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 20:37:43 -0500
Received: from an-out-0708.google.com ([209.85.132.248]:14526 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbZAZBhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 20:37:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=iQC0o/Oc6d9YjKH9bFz0d4nf8D3FPD2uMNRYABtQ3kwlPB0S93acK9wYe/R8BS6hnS
         3DZxeF7UfPOYtsESDm9paVxq2McEq++/tWXMUwZC742oLjl5cx8ckT5BHccGaPs85zHs
         Gv/VWPCP8Uq+qx4MD+WilBXjhLnBykJSfdV+0=
From: Alberto Bertogli <albertito@blitiri.com.ar>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org, corbet@lwn.net,
       Alberto Bertogli <albertito@blitiri.com.ar>
Subject: [PATCH] Fix typo in bio_split()'s documentation
Date: Sun, 25 Jan 2009 23:36:14 -0200
Message-Id: <1232933774-12210-1-git-send-email-albertito@blitiri.com.ar>
X-Mailer: git-send-email 1.6.1.302.gccd4d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alberto Bertogli <albertito@blitiri.com.ar>
---
 fs/bio.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 062299a..4fb5046 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1414,8 +1414,7 @@ static void bio_pair_end_2(struct bio *bi, int err)
 }
 
 /*
- * split a bio - only worry about a bio with a single page
- * in it's iovec
+ * split a bio - only worry about a bio with a single page in its iovec
  */
 struct bio_pair *bio_split(struct bio *bi, int first_sectors)
 {
-- 
1.6.1.302.gccd4d

