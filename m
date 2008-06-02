Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686AbYFBUXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbYFBUXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 16:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbYFBUWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 16:22:12 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:17242 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbYFBUWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 16:22:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=CaD546FfpwBidie7MmKexHO7bpUeLGzqKjRDNrlGB4Yp1IXWOh8rAvek1kjIdfWnjgqeiyBtnUGEv5xBGup+LPHWBUIB7ozQhiFORcKJ9Z0dy/3rV0icYZdoZ3iK7g8R8/7BLdDWI6W8hvCS+NO07jG1b++1LL2ryUvhAIy0uJs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 02 Jun 2008 22:23:34 +0200
Message-Id: <20080602202334.7265.5379.sendpatchset@localhost.localdomain>
In-Reply-To: <20080602202253.7265.23590.sendpatchset@localhost.localdomain>
References: <20080602202253.7265.23590.sendpatchset@localhost.localdomain>
Subject: [PATCH 6/9] delkin_cb: add missing __init/__exit tags
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/delkin_cb.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: b/drivers/ide/pci/delkin_cb.c
===================================================================
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -134,14 +134,12 @@ static struct pci_driver driver = {
 	.remove		= delkin_cb_remove,
 };
 
-static int
-delkin_cb_init (void)
+static int __init delkin_cb_init(void)
 {
 	return pci_register_driver(&driver);
 }
 
-static void
-delkin_cb_exit (void)
+static void __exit delkin_cb_exit(void)
 {
 	pci_unregister_driver(&driver);
 }
