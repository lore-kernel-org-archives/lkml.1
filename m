Return-Path: <linux-kernel-owner+w=401wt.eu-S1752243AbZLVUZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbZLVUZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 15:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbZLVUZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 15:25:14 -0500
Received: from kroah.org ([198.145.64.141]:55305 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbZLVUZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 15:25:12 -0500
Subject: patch usb-fix-section-mismatch-in-early-ehci-dbgp.patch added to gregkh-2.6 tree
To: JBeulich@novell.com, gregkh@suse.de, jason.wessel@windriver.com,
       jbeulich@novell.com, linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Tue, 22 Dec 2009 12:23:03 -0800
In-Reply-To: <4B06ACCD02000078000211E0@vpn.id2.novell.com>
Message-ID: <12615133833311@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: USB: fix section mismatch in early ehci dbgp

to my gregkh-2.6 tree.  Its filename is

    usb-fix-section-mismatch-in-early-ehci-dbgp.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From JBeulich@novell.com  Tue Dec 22 11:20:33 2009
From: "Jan Beulich" <JBeulich@novell.com>
Date: Fri, 20 Nov 2009 13:50:53 +0000
Subject: USB: fix section mismatch in early ehci dbgp
To: <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <jason.wessel@windriver.com>
Message-ID: <4B06ACCD02000078000211E0@vpn.id2.novell.com>
Content-Disposition: inline


Commit 917778267fbe67703ab7d5c6f0b7a05d4c3df485 removed __init from
ehci_wait_for_port(), but left it in place on ehci_reset_port(), which
is being called from the former function.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/usb/early/ehci-dbgp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/early/ehci-dbgp.c
+++ b/drivers/usb/early/ehci-dbgp.c
@@ -613,7 +613,7 @@ err:
 }
 EXPORT_SYMBOL_GPL(dbgp_external_startup);
 
-static int __init ehci_reset_port(int port)
+static int ehci_reset_port(int port)
 {
 	u32 portsc;
 	u32 delay_time, delay;

