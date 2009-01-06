Return-Path: <linux-kernel-owner+w=401wt.eu-S1758748AbZAFWbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748AbZAFWbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:31:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbZAFWOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:14:11 -0500
Received: from kroah.org ([198.145.64.141]:51320 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755722AbZAFWOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:14:07 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 48/60] gpio: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue,  6 Jan 2009 14:12:07 -0800
Message-Id: <1231279939-32728-48-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/gpio/gpiolib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 82020ab..35e7aea 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1213,7 +1213,7 @@ static int gpiolib_show(struct seq_file *s, void *unused)
 		if (dev)
 			seq_printf(s, ", %s/%s",
 				dev->bus ? dev->bus->name : "no-bus",
-				dev->bus_id);
+				dev_name(dev));
 		if (chip->label)
 			seq_printf(s, ", %s", chip->label);
 		if (chip->can_sleep)
-- 
1.6.0.4

