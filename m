Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbZCJQsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbZCJQsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756024AbZCJQnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:43:52 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:34636 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578AbZCJQnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:43:42 -0400
Message-Id: <6c780404c133d5d7ff3de57d54c9f951fb895ed7.1236702228.git.scott@canonical.com>
In-Reply-To: <cover.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
From: Scott James Remnant <scott@canonical.com>
Date: Tue, 10 Mar 2009 16:19:44 +0000
Subject: [PATCH 31/31] scsi: Add scsi type modalias to ch.
To: linux-kernel@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ch module is missing the scsi:t-0x08* alias that would cause it to
be auto-loaded when a device of that type if found by udev, requiring
udev to have a specific rule just for this one module.  This patch adds
the alias.

Signed-off-by: Scott James Remnant <scott@canonical.com>
---
 drivers/scsi/ch.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index af97254..7b1633a 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -41,6 +41,7 @@ MODULE_DESCRIPTION("device driver for scsi media changer devices");
 MODULE_AUTHOR("Gerd Knorr <kraxel@bytesex.org>");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_CHARDEV_MAJOR(SCSI_CHANGER_MAJOR);
+MODULE_ALIAS_SCSI_DEVICE(TYPE_MEDIUM_CHANGER);
 
 static int init = 1;
 module_param(init, int, 0444);
-- 
1.6.0.5

