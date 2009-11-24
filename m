Return-Path: <linux-kernel-owner+w=401wt.eu-S932467AbZKXJWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467AbZKXJWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 04:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932441AbZKXJWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 04:22:04 -0500
Received: from gw.wifiinternet.cz ([89.31.42.6]:32820 "EHLO monstr.eu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932429AbZKXJWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 04:22:02 -0500
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: linux-serial@vger.kernel.org, grant.likely@secretlab.ca,
       john.williams@petalogix.com, stable@kernel.org, chrisw@sous-sol.org,
       greg@kroah.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH] serial: 8250: Add ns16550a to OF compatible list
Date: Tue, 24 Nov 2009 10:21:42 +0100
Message-Id: <1259054502-28284-2-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1259054502-28284-1-git-send-email-monstr@monstr.eu>
References: <1259054502-28284-1-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 drivers/serial/of_serial.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/of_serial.c b/drivers/serial/of_serial.c
index 02406ba..b047c38 100644
--- a/drivers/serial/of_serial.c
+++ b/drivers/serial/of_serial.c
@@ -161,6 +161,7 @@ static int of_platform_serial_remove(struct of_device *ofdev)
 static struct of_device_id __devinitdata of_platform_serial_table[] = {
 	{ .type = "serial", .compatible = "ns8250",   .data = (void *)PORT_8250, },
 	{ .type = "serial", .compatible = "ns16450",  .data = (void *)PORT_16450, },
+	{ .type = "serial", .compatible = "ns16550a",  .data = (void *)PORT_16550A, },
 	{ .type = "serial", .compatible = "ns16550",  .data = (void *)PORT_16550, },
 	{ .type = "serial", .compatible = "ns16750",  .data = (void *)PORT_16750, },
 	{ .type = "serial", .compatible = "ns16850",  .data = (void *)PORT_16850, },
-- 
1.5.5.1

