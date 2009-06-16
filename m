Return-Path: <linux-kernel-owner+w=401wt.eu-S936455AbZFPF4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936455AbZFPF4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935074AbZFPFvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:10 -0400
Received: from kroah.org ([198.145.64.141]:48348 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761603AbZFPFvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:06 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 19/64] firmware: dvb/dvb-usb: prepare for FIRMWARE_NAME_MAX removal
Date: Mon, 15 Jun 2009 22:46:08 -0700
Message-Id: <1245131213-24168-19-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>

We're going to remove the FIRMWARE_NAME_MAX definition in order to avoid any
firmware name length restriction.
This patch changes the dvb_usb_device_properties firmware field accordingly.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Reviewed-by: Michael Krufky <mkrufky@kernellabs.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/media/dvb/dvb-usb/dvb-usb.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dvb-usb.h b/drivers/media/dvb/dvb-usb/dvb-usb.h
index 2d5352e..b515751 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb.h
@@ -196,7 +196,7 @@ struct dvb_usb_device_properties {
 #define CYPRESS_FX2     3
 	int        usb_ctrl;
 	int        (*download_firmware) (struct usb_device *, const struct firmware *);
-	const char firmware[FIRMWARE_NAME_MAX];
+	const char *firmware;
 	int        no_reconnect;
 
 	int size_of_priv;
-- 
1.6.3.2

