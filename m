Return-Path: <linux-kernel-owner+w=401wt.eu-S1760212AbZAFWa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760212AbZAFWa6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:30:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755787AbZAFWOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:14:10 -0500
Received: from kroah.org ([198.145.64.141]:51316 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756066AbZAFWOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:14:06 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Dave Airlie <airlied@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 47/60] gpu: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue,  6 Jan 2009 14:12:06 -0800
Message-Id: <1231279939-32728-47-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

CC: Dave Airlie <airlied@redhat.com>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/gpu/drm/drm_sysfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/drm_sysfs.c b/drivers/gpu/drm/drm_sysfs.c
index 65d72d0..5aa6780 100644
--- a/drivers/gpu/drm/drm_sysfs.c
+++ b/drivers/gpu/drm/drm_sysfs.c
@@ -488,7 +488,7 @@ int drm_sysfs_device_add(struct drm_minor *minor)
         else
                 minor_str = "card%d";
 
-	snprintf(minor->kdev.bus_id, BUS_ID_SIZE, minor_str, minor->index);
+	dev_set_name(&minor->kdev, minor_str, minor->index);
 
 	err = device_register(&minor->kdev);
 	if (err) {
-- 
1.6.0.4

