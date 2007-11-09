Return-Path: <linux-kernel-owner+w=401wt.eu-S1763663AbXKIXi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763663AbXKIXi5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:38:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755354AbXKIXit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:38:49 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:57152 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbXKIXis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:38:48 -0500
Message-id: <188679552254618572.slaby@pripojeni.net>
In-reply-to: <133622706419279219.slaby@pripojeni.net>
Subject: [PATCH 7/7] Char: riscom8, change rc_init_drivers prototype
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Fri, 9 Nov 2007 18:38:48 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

riscom8, change rc_init_drivers prototype

Let compiler decide if the rc_init_drivers function will be inlined and
mark it as __init, because it's called only from __init function.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit da1c9104ea38d0ca6e5ce0ee9be8cb6adff0ee71
tree 6878cf4f80d1e7bd4aa81a188dff5d13761ed867
parent 7a411a4d1729e34bd7dc6697a8eedec7dd989c32
author Jiri Slaby <jirislaby@gmail.com> Sat, 27 Oct 2007 00:31:26 +0200
committer Jiri Slaby <jirislaby@gmail.com> Fri, 09 Nov 2007 22:40:52 +0100

 drivers/char/riscom8.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/riscom8.c b/drivers/char/riscom8.c
index d130b87..9b19abf 100644
--- a/drivers/char/riscom8.c
+++ b/drivers/char/riscom8.c
@@ -1618,7 +1618,7 @@ static const struct tty_operations riscom_ops = {
 	.tiocmset = rc_tiocmset,
 };
 
-static inline int rc_init_drivers(void)
+static int __init rc_init_drivers(void)
 {
 	int error;
 	int i;
