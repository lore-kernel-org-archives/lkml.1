Return-Path: <linux-kernel-owner+w=401wt.eu-S933898AbYCEAsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933898AbYCEAsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 19:48:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761316AbYCEArn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 19:47:43 -0500
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2498 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760686AbYCEArl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 19:47:41 -0500
Subject: [PATCH] mm/slab.c - use angle brackets for include
From: Joe Perches <joe@perches.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 16:47:15 -0800
Message-Id: <1204678035.5180.94.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.1mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>

mm/slab.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 473e6c2..a37f897 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -333,7 +333,7 @@ static __always_inline int index_of(const size_t size)
 		return i; \
 	else \
 		i++;
-#include "linux/kmalloc_sizes.h"
+#include <linux/kmalloc_sizes.h>
 #undef CACHE
 		__bad_size();
 	} else



