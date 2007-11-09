Return-Path: <linux-kernel-owner+w=401wt.eu-S1763587AbXKIXhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763587AbXKIXhi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:37:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759875AbXKIXh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:37:28 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:57140 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759867AbXKIXh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:37:28 -0500
Message-id: <4809899577828134.slaby@pripojeni.net>
In-reply-to: <133622706419279219.slaby@pripojeni.net>
Subject: [PATCH 5/7] Char: mxser_new, ioaddresses are ulong
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Fri, 9 Nov 2007 18:37:28 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

mxser_new, ioaddresses are ulong

To not pass ulong address as int parameter, switch it to ulong.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit f412e3e0d4d012b7b57e381ae85ddfb1b5fc99bf
tree 3c00698655cc3b6fd7a99139607578a34358093d
parent d927dc37e63aa8347e596052615b85ff4936b3e2
author Jiri Slaby <jirislaby@gmail.com> Sat, 20 Oct 2007 22:56:49 +0200
committer Jiri Slaby <jirislaby@gmail.com> Fri, 09 Nov 2007 22:34:26 +0100

 drivers/char/mxser_new.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/mxser_new.c b/drivers/char/mxser_new.c
index bf1bee4..a4358ac 100644
--- a/drivers/char/mxser_new.c
+++ b/drivers/char/mxser_new.c
@@ -320,7 +320,7 @@ static struct mxser_mon_ext mon_data_ext;
 static int mxser_set_baud_method[MXSER_PORTS + 1];
 
 #ifdef CONFIG_PCI
-static int __devinit CheckIsMoxaMust(int io)
+static int __devinit CheckIsMoxaMust(unsigned long io)
 {
 	u8 oldmcr, hwid;
 	int i;
