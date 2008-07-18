Return-Path: <linux-kernel-owner+w=401wt.eu-S1756979AbYGRMP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979AbYGRMP5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbYGRMPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:15:50 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:29623 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbYGRMPt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:15:49 -0400
Message-Id: <4880A5A9.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Fri, 18 Jul 2008 13:16:09 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <sfrench@samba.org>
Cc: <linux-cifs-client@lists.samba.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] cifs: fix compiler warning on 64-bit arch-s
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 fs/cifs/asn1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.26/fs/cifs/asn1.c	2008-07-13 23:51:29.000000000 +0200
+++ 2.6.26-cifs-warning/fs/cifs/asn1.c	2008-07-17 15:23:11.000000000 +0200
@@ -400,7 +400,7 @@ asn1_oid_decode(struct asn1_ctx *ctx,
 	size = eoc - ctx->pointer + 1;
 
 	/* first subid actually encodes first two subids */
-	if (size < 2 || size > ULONG_MAX/sizeof(unsigned long))
+	if (size < 2 || size > UINT_MAX/sizeof(unsigned long))
 		return 0;
 
 	*oid = kmalloc(size * sizeof(unsigned long), GFP_ATOMIC);



