Return-Path: <linux-kernel-owner+w=401wt.eu-S1758692AbYJMJdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692AbYJMJdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 05:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756765AbYJMJco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:32:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56111 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758240AbYJMJcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:32:39 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 05/80] Blackfin Serial Driver: use __initdata for data,
	not __init
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 13 Oct 2008 10:32:35 +0100
Message-ID: <20081013093214.21645.13646.stgit@localhost.localdomain>
In-Reply-To: <20081013092758.21645.2359.stgit@localhost.localdomain>
References: <20081013092758.21645.2359.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/serial/bfin_5xx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 4a0d30b..4a023c6 100644
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

