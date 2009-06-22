Return-Path: <linux-kernel-owner+w=401wt.eu-S1758132AbZFVQqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132AbZFVQqF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 12:46:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757445AbZFVQow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 12:44:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53532 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757603AbZFVQov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 12:44:51 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 11/15] serial: samsung.c: mark s3c24xx_serial_remove as
	__devexit
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 22 Jun 2009 18:42:49 +0100
Message-ID: <20090622174248.25341.69938.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090622172929.25341.31151.stgit@t61.ukuu.org.uk>
References: <20090622172929.25341.31151.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Korsgaard <jacmet@sunsite.dk>

Mark the remove function as __devexit so it gets eliminated in
CONFIG_HOTPLUG=n builds.  Saves ~100 bytes.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Acked-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/serial/s3c2400.c |    2 +-
 drivers/serial/s3c2410.c |    2 +-
 drivers/serial/s3c2412.c |    2 +-
 drivers/serial/s3c2440.c |    2 +-
 drivers/serial/s3c24a0.c |    2 +-
 drivers/serial/s3c6400.c |    2 +-
 drivers/serial/samsung.c |    2 +-
 drivers/serial/samsung.h |    2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)


diff --git a/drivers/serial/s3c2400.c b/drivers/serial/s3c2400.c
index 4873f29..fb00ed5 100644
--- a/drivers/serial/s3c2400.c
+++ b/drivers/serial/s3c2400.c
@@ -78,7 +78,7 @@ static int s3c2400_serial_probe(struct platform_device *dev)
 
 static struct platform_driver s3c2400_serial_drv = {
 	.probe		= s3c2400_serial_probe,
-	.remove		= s3c24xx_serial_remove,
+	.remove		= __devexit_p(s3c24xx_serial_remove),
 	.driver		= {
 		.name	= "s3c2400-uart",
 		.owner	= THIS_MODULE,
diff --git a/drivers/serial/s3c2410.c b/drivers/serial/s3c2410.c
index 87c182e..b5d7cbc 100644
--- a/drivers/serial/s3c2410.c
+++ b/drivers/serial/s3c2410.c
@@ -90,7 +90,7 @@ static int s3c2410_serial_probe(struct platform_device *dev)
 
 static struct platform_driver s3c2410_serial_drv = {
 	.probe		= s3c2410_serial_probe,
-	.remove		= s3c24xx_serial_remove,
+	.remove		= __devexit_p(s3c24xx_serial_remove),
 	.driver		= {
 		.name	= "s3c2410-uart",
 		.owner	= THIS_MODULE,
diff --git a/drivers/serial/s3c2412.c b/drivers/serial/s3c2412.c
index fd017b3..11dcb90 100644
--- a/drivers/serial/s3c2412.c
+++ b/drivers/serial/s3c2412.c
@@ -123,7 +123,7 @@ static int s3c2412_serial_probe(struct platform_device *dev)
 
 static struct platform_driver s3c2412_serial_drv = {
 	.probe		= s3c2412_serial_probe,
-	.remove		= s3c24xx_serial_remove,
+	.remove		= __devexit_p(s3c24xx_serial_remove),
 	.driver		= {
 		.name	= "s3c2412-uart",
 		.owner	= THIS_MODULE,
diff --git a/drivers/serial/s3c2440.c b/drivers/serial/s3c2440.c
index 29cbb0a..06c5b0c 100644
--- a/drivers/serial/s3c2440.c
+++ b/drivers/serial/s3c2440.c
@@ -153,7 +153,7 @@ static int s3c2440_serial_probe(struct platform_device *dev)
 
 static struct platform_driver s3c2440_serial_drv = {
 	.probe		= s3c2440_serial_probe,
-	.remove		= s3c24xx_serial_remove,
+	.remove		= __devexit_p(s3c24xx_serial_remove),
 	.driver		= {
 		.name	= "s3c2440-uart",
 		.owner	= THIS_MODULE,
diff --git a/drivers/serial/s3c24a0.c b/drivers/serial/s3c24a0.c
index ebf2fd3..786a067 100644
--- a/drivers/serial/s3c24a0.c
+++ b/drivers/serial/s3c24a0.c
@@ -94,7 +94,7 @@ static int s3c24a0_serial_probe(struct platform_device *dev)
 
 static struct platform_driver s3c24a0_serial_drv = {
 	.probe		= s3c24a0_serial_probe,
-	.remove		= s3c24xx_serial_remove,
+	.remove		= __devexit_p(s3c24xx_serial_remove),
 	.driver		= {
 		.name	= "s3c24a0-uart",
 		.owner	= THIS_MODULE,
diff --git a/drivers/serial/s3c6400.c b/drivers/serial/s3c6400.c
index 3e37852..48f1a37 100644
--- a/drivers/serial/s3c6400.c
+++ b/drivers/serial/s3c6400.c
@@ -124,7 +124,7 @@ static int s3c6400_serial_probe(struct platform_device *dev)
 
 static struct platform_driver s3c6400_serial_drv = {
 	.probe		= s3c6400_serial_probe,
-	.remove		= s3c24xx_serial_remove,
+	.remove		= __devexit_p(s3c24xx_serial_remove),
 	.driver		= {
 		.name	= "s3c6400-uart",
 		.owner	= THIS_MODULE,
diff --git a/drivers/serial/samsung.c b/drivers/serial/samsung.c
index 93b5d75..c8851a0 100644
--- a/drivers/serial/samsung.c
+++ b/drivers/serial/samsung.c
@@ -1174,7 +1174,7 @@ int s3c24xx_serial_probe(struct platform_device *dev,
 
 EXPORT_SYMBOL_GPL(s3c24xx_serial_probe);
 
-int s3c24xx_serial_remove(struct platform_device *dev)
+int __devexit s3c24xx_serial_remove(struct platform_device *dev)
 {
 	struct uart_port *port = s3c24xx_dev_to_port(&dev->dev);
 
diff --git a/drivers/serial/samsung.h b/drivers/serial/samsung.h
index 7afb948..d3fe315 100644
--- a/drivers/serial/samsung.h
+++ b/drivers/serial/samsung.h
@@ -72,7 +72,7 @@ struct s3c24xx_uart_port {
 extern int s3c24xx_serial_probe(struct platform_device *dev,
 				struct s3c24xx_uart_info *uart);
 
-extern int s3c24xx_serial_remove(struct platform_device *dev);
+extern int __devexit s3c24xx_serial_remove(struct platform_device *dev);
 
 extern int s3c24xx_serial_initconsole(struct platform_driver *drv,
 				      struct s3c24xx_uart_info *uart);

