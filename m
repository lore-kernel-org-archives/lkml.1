Return-Path: <linux-kernel-owner+w=401wt.eu-S1757202AbYG0GEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202AbYG0GEu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbYG0GEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:04:41 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:32725 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbYG0GEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:04:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=S9qkF8p/HcnSTPz1uGx+F2rN/rt4MqqllOhpACDgsHLAWXUZcRFGxbqtmf1ToqUEJ2
         DibWeBu8X0iRz+vVlDyGNKC/uUL5W7ILdnH2BXRNUx2c5/b51UO/XXJpCQZ7TqD0npGP
         y2We9RCSFzqyJI7Zcd7gq/px4Umg1vGdEhF+I=
From: Bryan Wu <cooloney@kernel.org>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/8] Blackfin Serial Driver: use __initdata for data, not __init
Date: Sun, 27 Jul 2008 14:04:00 +0800
Message-Id: <1217138647-18227-2-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1217138647-18227-1-git-send-email-cooloney@kernel.org>
References: <1217138647-18227-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/bfin_5xx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index fd9bb77..052ce73 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -1056,7 +1056,7 @@ static __init void early_serial_write(struct console *con, const char *s,
 	}
 }
 
-static struct __init console bfin_early_serial_console = {
+static struct __initdata console bfin_early_serial_console = {
 	.name = "early_BFuart",
 	.write = early_serial_write,
 	.device = uart_console_device,
-- 
1.5.6

