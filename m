Return-Path: <linux-kernel-owner+w=401wt.eu-S1757703AbXJ2NPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703AbXJ2NPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 09:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbXJ2NPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 09:15:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbXJ2NPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 09:15:43 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] NOMMU: mm/nommu.c needs linux/module.h
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Mon, 29 Oct 2007 13:15:39 +0000
Message-ID: <20071029131539.10690.645.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

mm/nommu.c needs to #include linux/module.h for it to understand EXPORT_*()
macros.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 mm/nommu.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 8f09333..35622c5 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -12,6 +12,7 @@
  *  Copyright (c) 2002      Greg Ungerer <gerg@snapgear.com>
  */
 
+#include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/mman.h>
 #include <linux/swap.h>

