Return-Path: <linux-kernel-owner+w=401wt.eu-S1751554AbZAYW4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbZAYW4a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 17:56:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbZAYW4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 17:56:22 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:25871 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbZAYW4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 17:56:21 -0500
Subject: rapidio: struct device - replace bus_id with dev_name(),
 dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: mporter@kernel.crashing.org
Cc: gregkh <gregkh@suse.de>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 25 Jan 2009 23:55:29 +0100
Message-Id: <1232924129.2924.20.camel@nga>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: rapidio: struct device - replace bus_id with dev_name(), dev_set_name()

Cc: mporter@kernel.crashing.org
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/rapidio/rio-driver.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rapidio/rio-driver.c
+++ b/drivers/rapidio/rio-driver.c
@@ -193,7 +193,7 @@ static int rio_match_bus(struct device *
 }
 
 static struct device rio_bus = {
-	.bus_id = "rapidio",
+	.init_name = "rapidio",
 };
 
 struct bus_type rio_bus_type = {

