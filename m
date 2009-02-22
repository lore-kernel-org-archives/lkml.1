Return-Path: <linux-kernel-owner+w=401wt.eu-S1756454AbZBVAGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454AbZBVAGK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 19:06:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755602AbZBVAFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 19:05:50 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:35364 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193AbZBVAFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 19:05:49 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 15/16] ipv6: fix sparse warning: Using plain integer as NULL
	pointer
To: trivial@kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 22 Feb 2009 01:05:44 +0100
Message-ID: <20090222000541.17557.51181.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
References: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warning:
  net/ipv6/xfrm6_state.c:72:26: warning: Using plain integer as NULL pointer

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 net/ipv6/xfrm6_state.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv6/xfrm6_state.c b/net/ipv6/xfrm6_state.c
index 0e685b0..f417b77 100644
--- a/net/ipv6/xfrm6_state.c
+++ b/net/ipv6/xfrm6_state.c
@@ -69,7 +69,7 @@ __xfrm6_sort(void **dst, void **src, int n, int (*cmp)(void *p), int maxclass)
 
 	for (i = 0; i < n; i++) {
 		dst[count[class[i] - 1]++] = src[i];
-		src[i] = 0;
+		src[i] = NULL;
 	}
 
 	return 0;

