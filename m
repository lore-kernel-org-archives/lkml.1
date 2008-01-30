Return-Path: <linux-kernel-owner+w=401wt.eu-S933047AbYA3VUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933047AbYA3VUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758611AbYA3VHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:07:46 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:31693 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758507AbYA3VHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:07:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=N+m936nZkgjHd04eEKbfk7lwsvXxa2nFma5/SdSIEARhmip2Gs/3oRHpHmzlmEibLWs+m63zeLo/MW0FtLR9olIma85dvLdWXnMKsRJrn/INAolgI3c1sak1QXK6o7c7kZBhTHP8ydohqMOdIZy974C7bEK6yV6eoNaIpur7BHI=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 10/10] udf: constify udf_bitmap_lookup array
Date: Wed, 30 Jan 2008 22:04:00 +0100
Message-Id: <1201727040-6769-11-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1201727040-6769-1-git-send-email-marcin.slusarz@gmail.com>
References: <1201727040-6769-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

udf_bitmap_lookup never changes, so constify it

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Jan Kara <jack@suse.cz>
---
 fs/udf/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 3afe764..6bb2a5b 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1969,7 +1969,7 @@ static int udf_statfs(struct dentry *dentry, struct kstatfs *buf)
 	return 0;
 }
 
-static unsigned char udf_bitmap_lookup[16] = {
+static const unsigned char udf_bitmap_lookup[16] = {
 	0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4
 };
 
-- 
1.5.3.7

