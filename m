Return-Path: <linux-kernel-owner+w=401wt.eu-S1757269AbYGKOhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbYGKOhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 10:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbYGKOhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 10:37:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621AbYGKOhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 10:37:06 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Fix the fcpnp_driver declaration to only exist if CONFIG_PNP=y
To: bjorn.helgaas@hp.com, akpm@linux-foundation.org
Cc: dhowells@redhat.com, kkeil@suse.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org
Date: Fri, 11 Jul 2008 15:36:48 +0100
Message-ID: <20080711143648.19650.93895.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the fcpnp_driver declaration to only exist if CONFIG_PNP=y as it's only
accessed in that case.

The PNP=n variant was added by patch 30d55e71a81b1f5a8136f191dc9f4c21f18e77e6.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/isdn/hisax/hisax_fcpcipnp.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)


diff --git a/drivers/isdn/hisax/hisax_fcpcipnp.c b/drivers/isdn/hisax/hisax_fcpcipnp.c
index c0b4db2..1925118 100644
--- a/drivers/isdn/hisax/hisax_fcpcipnp.c
+++ b/drivers/isdn/hisax/hisax_fcpcipnp.c
@@ -974,8 +974,6 @@ static struct pnp_driver fcpnp_driver = {
 	.remove		= __devexit_p(fcpnp_remove),
 	.id_table	= fcpnp_ids,
 };
-#else
-static struct pnp_driver fcpnp_driver;
 #endif
 
 static void __devexit fcpci_remove(struct pci_dev *pdev)

