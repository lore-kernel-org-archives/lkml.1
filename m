Return-Path: <linux-kernel-owner+w=401wt.eu-S1757139AbZFHXGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139AbZFHXGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 19:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755477AbZFHXGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 19:06:07 -0400
Received: from xes-mad.com ([216.165.139.214]:50154 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755399AbZFHXGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 19:06:06 -0400
X-Greylist: delayed 851 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Jun 2009 19:06:06 EDT
From: Nate Case <ncase@xes-inc.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org, Nate Case <ncase@xes-inc.com>
Subject: [PATCH next 2/2] gpio: pca953x: Add support for PCA9556
Date: Mon,  8 Jun 2009 17:51:53 -0500
Message-Id: <1244501513-19836-3-git-send-email-ncase@xes-inc.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1244501513-19836-2-git-send-email-ncase@xes-inc.com>
References: <1244501513-19836-1-git-send-email-ncase@xes-inc.com>
 <1244501513-19836-2-git-send-email-ncase@xes-inc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCA9556 is the software-compatible predecessor to the PCA9557, so add
it to the supported I2C device ID table.

Signed-off-by: Nate Case <ncase@xes-inc.com>
---
 drivers/gpio/pca953x.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index 258246e..bbd08a9 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -36,6 +36,7 @@ static const struct i2c_device_id pca953x_id[] = {
 	{ "pca9539", 16, },
 	{ "pca9554", 8, },
 	{ "pca9555", 16, },
+	{ "pca9556", 8, },
 	{ "pca9557", 8, },
 
 	{ "max7310", 8, },
-- 
1.6.0.2

