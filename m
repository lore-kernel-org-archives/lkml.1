Return-Path: <linux-kernel-owner+w=401wt.eu-S1753710AbYJOCSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710AbYJOCSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 22:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbYJOCSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 22:18:39 -0400
Received: from argonath.las.ic.unicamp.br ([143.106.60.116]:36629 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbYJOCSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 22:18:38 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Oct 2008 22:18:38 EDT
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: linux-serial@vger.kernel.org, gregkh@suse.de
Subject: [PATCH] 8250: remove ununsed variable
Date: Tue, 14 Oct 2008 23:12:18 -0300
Message-Id: <1224036738-16613-1-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.5.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'i' isn't used in serial8250_init()

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
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
1.5.6.4

