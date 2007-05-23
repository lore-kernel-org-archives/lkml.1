Return-Path: <linux-kernel-owner+w=401wt.eu-S1755649AbXEWTPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649AbXEWTPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 15:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755343AbXEWTPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 15:15:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754956AbXEWTPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 15:15:24 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/4] AFS: Add TestSetPageError()
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Wed, 23 May 2007 20:15:19 +0100
Message-ID: <20070523191518.24135.81257.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a TestSetPageError() macro to the suite of page flag manipulators.  This
can be used by AFS to prevent over-excision of rejected writes from the page
cache.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/page-flags.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index ae2d79f..cc8d952 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -121,6 +121,7 @@
 #define PageError(page)		test_bit(PG_error, &(page)->flags)
 #define SetPageError(page)	set_bit(PG_error, &(page)->flags)
 #define ClearPageError(page)	clear_bit(PG_error, &(page)->flags)
+#define TestSetPageError(page)	test_and_set_bit(PG_error, &(page)->flags)
 
 #define PageReferenced(page)	test_bit(PG_referenced, &(page)->flags)
 #define SetPageReferenced(page)	set_bit(PG_referenced, &(page)->flags)

