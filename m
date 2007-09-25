Return-Path: <linux-kernel-owner+w=401wt.eu-S1755092AbXIYXZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbXIYXZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 19:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbXIYXZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 19:25:28 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:26959 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbXIYXZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 19:25:27 -0400
Date: Tue, 25 Sep 2007 16:24:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH -mm] swap: fix function declaration
Message-Id: <20070925162435.d9563b44.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix function declaration:
mm/swap.c:130:22: warning: non-ANSI function declaration of function 'move_tail_pages'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 mm/swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.23-rc8-mm1.orig/mm/swap.c
+++ linux-2.6.23-rc8-mm1/mm/swap.c
@@ -127,7 +127,7 @@ static void pagevec_move_tail(struct pag
 
 static DEFINE_PER_CPU(struct pagevec, rotate_pvecs) = { 0, };
 
-void move_tail_pages()
+void move_tail_pages(void)
 {
 	unsigned long flags;
 	struct pagevec *pvec;
