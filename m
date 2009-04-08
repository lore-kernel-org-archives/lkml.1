Return-Path: <linux-kernel-owner+w=401wt.eu-S1764693AbZDHLcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764693AbZDHLcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764235AbZDHLY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:24:26 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:60533 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932122AbZDHLYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:24:25 -0400
X-Sasl-enc: 9Jy/x2qk5CMRe2elYDCikTyfJ0u6h2lmon5J/UoQSinB 1239189819
From: Jack Stone <jwjstone@fastmail.fm>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, kernel-janitors@vger.kernel.org,
       Jack Stone <jwjstone@fastmail.fm>
Subject: [PATCH 20/56] inflate: Remove void casts
Date: Wed,  8 Apr 2009 12:21:52 +0100
Message-Id: <1239189748-11703-21-git-send-email-jwjstone@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1239189748-11703-20-git-send-email-jwjstone@fastmail.fm>
References: <>
 <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-8-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-9-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-10-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-11-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-12-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-13-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-17-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-19-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-20-git-send-email-jwjstone@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---
 lib/inflate.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/inflate.c b/lib/inflate.c
index 1a8e8a9..4b672f9 100644
--- a/lib/inflate.c
+++ b/lib/inflate.c
@@ -249,7 +249,7 @@ static void *malloc(int size)
 
        malloc_ptr = (malloc_ptr + 3) & ~3;     /* Align */
 
-       p = (void *)malloc_ptr;
+       p = malloc_ptr;
        malloc_ptr += size;
 
        if (free_mem_end_ptr && malloc_ptr >= free_mem_end_ptr)
@@ -481,7 +481,7 @@ DEBG1("3 ");
         z = 1 << j;             /* table entries for j-bit table */
 
         /* allocate and link in new table */
-        if ((q = (struct huft *)malloc((z + 1)*sizeof(struct huft))) ==
+        if ((q = malloc((z + 1)*sizeof(struct huft))) ==
             (struct huft *)NULL)
         {
           if (h)
-- 
1.5.4.3

