Return-Path: <linux-kernel-owner+w=401wt.eu-S936407AbZFPFz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936407AbZFPFz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934990AbZFPFvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:09 -0400
Received: from kroah.org ([198.145.64.141]:48346 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934235AbZFPFvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:05 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Michel Ludwig <michel.ludwig@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 18/64] firmware: tuners/xc2028: prepare for FIRMWARE_NAME_MAX removal
Date: Mon, 15 Jun 2009 22:46:07 -0700
Message-Id: <1245131213-24168-18-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>

We're going to remove the FIRMWARE_NAME_MAX definition in order to avoid any
firmware name length restriction.
This patch gets rid of the xc2028 FIRMWARE_NAME_MAX reference.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Michel Ludwig <michel.ludwig@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/media/common/tuners/tuner-xc2028.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/common/tuners/tuner-xc2028.c b/drivers/media/common/tuners/tuner-xc2028.c
index 1adce9f..7636c33 100644
--- a/drivers/media/common/tuners/tuner-xc2028.c
+++ b/drivers/media/common/tuners/tuner-xc2028.c
@@ -48,7 +48,7 @@ MODULE_PARM_DESC(audio_std,
 	"NICAM/A\n"
 	"NICAM/B\n");
 
-static char firmware_name[FIRMWARE_NAME_MAX];
+static char firmware_name[30];
 module_param_string(firmware_name, firmware_name, sizeof(firmware_name), 0);
 MODULE_PARM_DESC(firmware_name, "Firmware file name. Allows overriding the "
 				"default firmware name\n");
-- 
1.6.3.2

