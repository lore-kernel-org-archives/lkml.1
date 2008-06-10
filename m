Return-Path: <linux-kernel-owner+w=401wt.eu-S1759006AbYFJVWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759006AbYFJVWD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 17:22:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753812AbYFJVVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 17:21:54 -0400
Received: from mail.macqel.be ([194.78.208.39]:14734 "EHLO mail.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657AbYFJVVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 17:21:53 -0400
Date: Tue, 10 Jun 2008 23:21:49 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] driver/char/generic_nvram : fix banner
Message-ID: <20080610212149.GB23486@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody,

The generic nvram driver announces itself as
	'Macintosh non-volatile memory driver'
instead of 'Generic non-volatile memory driver'.  Fix that.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>

diff -r 184e1bb486cf drivers/char/generic_nvram.c
--- a/drivers/char/generic_nvram.c	Mon Jun  9 19:30:13 2008 -0700
+++ b/drivers/char/generic_nvram.c	Tue Jun 10 13:25:22 2008 +0200
@@ -133,7 +133,7 @@ static struct miscdevice nvram_dev = {
 
 int __init nvram_init(void)
 {
-	printk(KERN_INFO "Macintosh non-volatile memory driver v%s\n",
+	printk(KERN_INFO "Generic non-volatile memory driver v%s\n",
 		NVRAM_VERSION);
 	return misc_register(&nvram_dev);
 }
