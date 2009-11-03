Return-Path: <linux-kernel-owner+w=401wt.eu-S1756532AbZKCKI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532AbZKCKI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 05:08:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756192AbZKCKI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 05:08:58 -0500
Received: from mxout-08.mxes.net ([216.86.168.183]:22380 "EHLO
	mxout-08.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbZKCKIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 05:08:55 -0500
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: greg@kroah.com
Cc: linux-kbuild@vger.kernel.org, carmelo73@gmail.com,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: [PATCH 08/10] lib: bsearch - remove redundant special case for arrays of size 0
Date: Tue,  3 Nov 2009 10:06:20 +0000
Message-Id: <1257242782-10496-9-git-send-email-alan-jenkins@tuffmail.co.uk>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com>
References: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com>
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
1.6.3.2

