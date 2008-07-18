Return-Path: <linux-kernel-owner+w=401wt.eu-S1758417AbYGRMT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758417AbYGRMT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756109AbYGRMTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:19:19 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:29757 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911AbYGRMTS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:19:18 -0400
Message-Id: <4880A67B.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Fri, 18 Jul 2008 13:19:39 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] fbcon: remove stray semicolons
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 drivers/video/console/fbcon.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.26/drivers/video/console/fbcon.h	2008-07-13 23:51:29.000000000 +0200
+++ 2.6.26-fbcon-stray-semicolon/drivers/video/console/fbcon.h	2008-07-15 14:51:28.000000000 +0200
@@ -147,9 +147,9 @@ static inline int attr_col_ec(int shift,
 }
 
 #define attr_bgcol_ec(bgshift,vc,info)		\
-	attr_col_ec(bgshift,vc,info,0);
+	attr_col_ec(bgshift,vc,info,0)
 #define attr_fgcol_ec(fgshift,vc,info)		\
-	attr_col_ec(fgshift,vc,info,1);
+	attr_col_ec(fgshift,vc,info,1)
 
 /* Font */
 #define REFCOUNT(fd)	(((int *)(fd))[-1])



