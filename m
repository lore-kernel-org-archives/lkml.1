Return-Path: <linux-kernel-owner+w=401wt.eu-S1757255AbZCJQqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255AbZCJQqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755976AbZCJQnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:43:46 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:34594 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915AbZCJQni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:43:38 -0400
Message-Id: <096a96f38cc7226c591686098ea30fe29a4a84fb.1236702228.git.scott@canonical.com>
In-Reply-To: <cover.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
From: Scott James Remnant <scott@canonical.com>
Date: Mon, 2 Mar 2009 18:23:13 +0000
Subject: [PATCH 15/31] sbus: Auto-load openprom module when device opened.
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The openprom module is missing the char-major-10-139 alias that would
cause it to be auto-loaded when a device of that type is opened.  This
patch adds the alias.

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/sbus/char/openprom.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/sbus/char/openprom.c b/drivers/sbus/char/openprom.c
index 29dc735..124f660 100644
--- a/drivers/sbus/char/openprom.c
+++ b/drivers/sbus/char/openprom.c
@@ -51,6 +51,7 @@ MODULE_AUTHOR("Thomas K. Dyas (tdyas@noc.rutgers.edu) and Eddie C. Dost  (ecd@sk
 MODULE_DESCRIPTION("OPENPROM Configuration Driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION("1.0");
+MODULE_ALIAS_MISCDEV(SUN_OPENPROM_MINOR);
 
 /* Private data kept by the driver for each descriptor. */
 typedef struct openprom_private_data
-- 
1.6.0.5

