Return-Path: <linux-kernel-owner+w=401wt.eu-S1757763AbZCJQs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763AbZCJQs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756063AbZCJQnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:43:53 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:34628 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755397AbZCJQnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:43:41 -0400
Message-Id: <c9944f91c6740450d11cb26c4e8e19e2cb612abe.1236702228.git.scott@canonical.com>
In-Reply-To: <cover.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
From: Scott James Remnant <scott@canonical.com>
Date: Mon, 2 Mar 2009 18:46:15 +0000
Subject: [PATCH 26/31] usb: Auto-load cdc_acm module when device opened.
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, linux-usb@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cdc_acm module is missing the char-major-166-* alias that would
cause it to be auto-loaded when a device of that type is opened.  This
patch adds the alias.

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/usb/class/cdc-acm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index b3d5a23..85f22c6 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1493,4 +1493,4 @@ module_exit(acm_exit);
 MODULE_AUTHOR( DRIVER_AUTHOR );
 MODULE_DESCRIPTION( DRIVER_DESC );
 MODULE_LICENSE("GPL");
-
+MODULE_ALIAS_CHARDEV_MAJOR(ACM_TTY_MAJOR);
-- 
1.6.0.5

