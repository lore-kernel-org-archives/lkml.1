Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbZKGVEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbZKGVEw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 16:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbZKGVE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 16:04:29 -0500
Received: from mxout-08.mxes.net ([216.86.168.183]:39949 "EHLO
	mxout-08.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbZKGVEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 16:04:22 -0500
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: [PATCH 08/10] lib: bsearch - remove redundant special case for arrays of size 0
Date: Sat,  7 Nov 2009 21:03:59 +0000
Message-Id: <1257627841-15817-8-git-send-email-alan-jenkins@tuffmail.co.uk>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <4AF5DF9F.5020208@tuffmail.co.uk>
References: <4AF5DF9F.5020208@tuffmail.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 24 Sep 2009, Rusty Russell wrote:
>
>> The if (num == 0) line is superfluous.

On 9/27/09, Tim Abbott <tabbott@ksplice.com> wrote:
>
> You are quite right.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 lib/bsearch.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/lib/bsearch.c b/lib/bsearch.c
index 4297c98..2e70664 100644
--- a/lib/bsearch.c
+++ b/lib/bsearch.c
@@ -34,8 +34,6 @@ void *bsearch(const void *key, const void *base, size_t num, size_t size,
 	      int (*cmp)(const void *key, const void *elt))
 {
 	int start = 0, end = num - 1, mid, result;
-	if (num == 0)
-		return NULL;
 
 	while (start <= end) {
 		mid = (start + end) / 2;
-- 
1.6.3.3

