Return-Path: <linux-kernel-owner+w=401wt.eu-S1756801AbYGVFWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbYGVFWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756069AbYGVFVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:21:49 -0400
Received: from cantor.suse.de ([195.135.220.2]:53682 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755794AbYGVFVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:21:48 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH 04/79] Firmware: fix typo in example code
Date: Mon, 21 Jul 2008 22:18:28 -0700
Message-Id: <1216703983-21448-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not like this stuff even builds right now, but this will make
Randy's scripts happy :)


Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 .../firmware_sample_firmware_class.c               |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/samples/firmware_class/firmware_sample_firmware_class.c b/samples/firmware_class/firmware_sample_firmware_class.c
index 9392116..e6cf7a4 100644
--- a/samples/firmware_class/firmware_sample_firmware_class.c
+++ b/samples/firmware_class/firmware_sample_firmware_class.c
@@ -124,7 +124,7 @@ static int fw_setup_class_device(struct class_device *class_dev,
 	class_dev->class_id[BUS_ID_SIZE-1] = '\0';
 	class_dev->dev = device;
 
-	class_dev->class = &firmware_class,
+	class_dev->class = &firmware_class;
 	class_set_devdata(class_dev, fw_priv);
 	retval = class_device_register(class_dev);
 	if (retval) {
-- 
1.5.6.3

