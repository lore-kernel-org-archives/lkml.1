Return-Path: <linux-kernel-owner+w=401wt.eu-S1758417AbZHQXqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758417AbZHQXqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 19:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758295AbZHQXqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 19:46:32 -0400
Received: from smtp-out.google.com ([216.239.33.17]:34332 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883AbZHQXqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 19:46:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=ZVwjQnOllwH3onPBGt6+muBPC3ZzFzfLS4SSx3YSpLrGi3Zn4lg5Py2w/6gUz/Mfy
	FTXJznjZvKVUcKy3Aq+gA==
Date: Mon, 17 Aug 2009 16:46:23 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: [patch 2/3] flex_array: fix flex_array_free_parts comment
In-Reply-To: <alpine.DEB.2.00.0908171644540.30313@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0908171645270.30313@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0908171644540.30313@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

flex_array_free_parts() does not take `src' or `element_nr' formals, so
remove their respective comments.

Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 lib/flex_array.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/lib/flex_array.c b/lib/flex_array.c
--- a/lib/flex_array.c
+++ b/lib/flex_array.c
@@ -122,9 +122,6 @@ static int fa_element_to_part_nr(struct flex_array *fa, int element_nr)
 
 /**
  * flex_array_free_parts - just free the second-level pages
- * @src:	address of data to copy into the array
- * @element_nr:	index of the position in which to insert
- * 		the new element.
  *
  * This is to be used in cases where the base 'struct flex_array'
  * has been statically allocated and should not be free.
