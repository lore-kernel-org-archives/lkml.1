Return-Path: <linux-kernel-owner+w=401wt.eu-S1757686AbZCPLBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686AbZCPLBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 07:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbZCPLBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 07:01:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57826 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbZCPLBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 07:01:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Point the UNEVICTABLE_LRU config option at the documentation
To: lee.schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com,
       minchan.kim@gmail.com
Cc: dhowells@redhat.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Date: Mon, 16 Mar 2009 10:59:45 +0000
Message-ID: <20090316105945.18131.82359.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Point the UNEVICTABLE_LRU config option at the documentation describing the
option.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 mm/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/mm/Kconfig b/mm/Kconfig
index b53427a..57971d2 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -213,6 +213,8 @@ config UNEVICTABLE_LRU
 	  will use one page flag and increase the code size a little,
 	  say Y unless you know what you are doing.
 
+	  See Documentation/vm/unevictable-lru.txt for more information.
+
 config HAVE_MLOCK
 	bool
 	default y if MMU=y

