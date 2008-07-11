Return-Path: <linux-kernel-owner+w=401wt.eu-S1758376AbYGKMsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758376AbYGKMsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 08:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbYGKMsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 08:48:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbYGKMsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 08:48:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Remove an unused variable from the (i)Stallion serial drivers
To: alan@redhat.com, akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Fri, 11 Jul 2008 13:48:32 +0100
Message-ID: <20080711124832.24130.461.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove an unused variable from the (intelligent) Stallion serial drivers.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/char/istallion.c |    1 -
 drivers/char/stallion.c  |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)


diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
index 9e73308..89d56c0 100644
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
@@ -1660,7 +1660,6 @@ static int stli_ioctl(struct tty_struct *tty, struct file *file, unsigned int cm
 {
 	struct stliport *portp;
 	struct stlibrd *brdp;
-	unsigned int ival;
 	int rc;
 	void __user *argp = (void __user *)arg;
 
diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
index 45aeeea..2eeb9b2 100644
--- a/drivers/char/stallion.c
+++ b/drivers/char/stallion.c
@@ -1255,7 +1255,6 @@ static int stl_tiocmset(struct tty_struct *tty, struct file *file,
 static int stl_ioctl(struct tty_struct *tty, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct stlport	*portp;
-	unsigned int	ival;
 	int		rc;
 	void __user *argp = (void __user *)arg;
 

