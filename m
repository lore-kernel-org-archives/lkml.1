Return-Path: <linux-kernel-owner+w=401wt.eu-S1758856AbYDVPNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856AbYDVPNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765216AbYDVPNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:13:12 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:15603 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763852AbYDVPNJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:13:09 -0400
Message-Id: <480E1CAE.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Tue, 22 Apr 2008 16:13:18 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH] remove stray semicolons from attr_{b,f}gcol_ec()
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

--- linux-2.6.25/drivers/video/console/fbcon.h	2008-04-17 04:49:44.000000000 +0200
+++ 2.6.25-fbcon-attr-col-macros/drivers/video/console/fbcon.h	2008-04-15 10:49:20.000000000 +0200
@@ -143,9 +143,9 @@ static inline int attr_col_ec(int shift,
 }
 
 #define attr_bgcol_ec(bgshift,vc,info)		\
-	attr_col_ec(bgshift,vc,info,0);
+	attr_col_ec(bgshift,vc,info,0)
 #define attr_fgcol_ec(fgshift,vc,info)		\
-	attr_col_ec(fgshift,vc,info,1);
+	attr_col_ec(fgshift,vc,info,1)
 
 /* Font */
 #define REFCOUNT(fd)	(((int *)(fd))[-1])



