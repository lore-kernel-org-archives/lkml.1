Return-Path: <linux-kernel-owner+w=401wt.eu-S1754952AbYLISox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952AbYLISox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 13:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754264AbYLISop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 13:44:45 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:43486 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213AbYLISoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 13:44:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=Qij5WTg7poogsHeRZTZUdeLL6AaGKN9m8HCcsLUrqvRqaA7r2PCw4vt86fq72WrgdJ
         OrExTGMMT55s7S+MHZvLjlnSCi6SZQdZS6AP7E6sx36WHYMIkYerZwip9uwyIYzc+p9s
         armFHcNzeIBLGhxrshj7CGq+FM+pYGx0nR5HM=
Message-ID: <493EBC99.8050702@gmail.com>
Date: Tue, 09 Dec 2008 19:44:41 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 13/33] Input: Make static
References: <493EA286.7080500@gmail.com>
In-Reply-To: <493EA286.7080500@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse asked whether these could be static.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/input/mouse/gpio_mouse.c |    2 +-
 drivers/input/tablet/wacom_wac.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/mouse/gpio_mouse.c b/drivers/input/mouse/gpio_mouse.c
index 72cf5e3..0db8d16 100644
--- a/drivers/input/mouse/gpio_mouse.c
+++ b/drivers/input/mouse/gpio_mouse.c
@@ -173,7 +173,7 @@ static int __devexit gpio_mouse_remove(struct platform_device *pdev)
 /* work with hotplug and coldplug */
 MODULE_ALIAS("platform:gpio_mouse");
 
-struct platform_driver gpio_mouse_device_driver = {
+static struct platform_driver gpio_mouse_device_driver = {
 	.remove		= __devexit_p(gpio_mouse_remove),
 	.driver		= {
 		.name	= "gpio_mouse",
diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index 8dc8d1e..2638811 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -535,7 +535,7 @@ static int wacom_intuos_irq(struct wacom_wac *wacom, void *wcombo)
 	return 1;
 }
 
-int wacom_tpc_irq(struct wacom_wac *wacom, void *wcombo)
+static int wacom_tpc_irq(struct wacom_wac *wacom, void *wcombo)
 {
 	char *data = wacom->data;
 	int prox = 0, pressure;

