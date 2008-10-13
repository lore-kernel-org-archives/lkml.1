Return-Path: <linux-kernel-owner+w=401wt.eu-S1759044AbYJMW50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759044AbYJMW50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 18:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755844AbYJMW5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 18:57:17 -0400
Received: from smtp.cs.aau.dk ([130.225.194.6]:37535 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755642AbYJMW5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 18:57:17 -0400
Subject: [PATCH] serial: remove unused variable
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@redhat.com>, David Miller <davem@davemloft.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=utf-8
Date: Tue, 14 Oct 2008 00:58:31 +0200
Message-Id: <1223938711.21717.16.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following compile warning:

drivers/serial/8250.c: In function 'serial8250_init':
drivers/serial/8250.c:2963: warning: unused variable 'i'

that was introduced by b70ac771 (serial: allow 8250 to be used on sparc)
that removed the last use of the variable.

Signed-off-by: Simon Holm Thøgersen <odie@cs.aau.dk>
---
 drivers/serial/8250.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index d4104a3..625fc20 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2960,7 +2960,7 @@ EXPORT_SYMBOL(serial8250_unregister_port);
 
 static int __init serial8250_init(void)
 {
-	int ret, i;
+	int ret;
 
 	if (nr_uarts > UART_NR)
 		nr_uarts = UART_NR;
-- 
1.5.6.2.255.gbed62

