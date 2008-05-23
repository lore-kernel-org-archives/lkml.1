Return-Path: <linux-kernel-owner+w=401wt.eu-S1758465AbYEWRof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758465AbYEWRof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 13:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbYEWRoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 13:44:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756398AbYEWRoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 13:44:17 -0400
Subject: [PATCH] fujitsu-laptop: autload module on Lifebook P1510D
From: Dan Williams <dcbw@redhat.com>
To: jwoithe@physics.adelaide.edu.au
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1211561193.31559.41.camel@localhost.localdomain>
References: <1211561193.31559.41.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 23 May 2008 13:44:20 -0400
Message-Id: <1211564660.11020.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dan Williams <dcbw@redhat.com>

Put a [PATCH] in the title so people will care...

diff --git a/drivers/misc/fujitsu-laptop.c b/drivers/misc/fujitsu-laptop.c
index e2e7c05..6d14e8f 100644
--- a/drivers/misc/fujitsu-laptop.c
+++ b/drivers/misc/fujitsu-laptop.c
@@ -352,3 +352,9 @@ MODULE_AUTHOR("Jonathan Woithe");
 MODULE_DESCRIPTION("Fujitsu laptop extras support");
 MODULE_VERSION(FUJITSU_DRIVER_VERSION);
 MODULE_LICENSE("GPL");
+
+static struct pnp_device_id pnp_ids[] = {
+	{ .id = "FUJ02bf" },
+	{ .id = "" }
+};
+MODULE_DEVICE_TABLE(pnp, pnp_ids);


