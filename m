Return-Path: <linux-kernel-owner+w=401wt.eu-S936160AbZFPFxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936160AbZFPFxY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760894AbZFPFu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:50:58 -0400
Received: from kroah.org ([198.145.64.141]:48312 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755637AbZFPFu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:50:57 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Dmitry Torokhov <dtor@mail.ru>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/64] Driver core: fix comment for device_attach()
Date: Mon, 15 Jun 2009 22:45:58 -0700
Message-Id: <1245131213-24168-9-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

We are looking for matching drivers, not devices.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/dd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index efd00de..f010687 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -226,7 +226,7 @@ static int __device_attach(struct device_driver *drv, void *data)
  * pair is found, break out and return.
  *
  * Returns 1 if the device was bound to a driver;
- * 0 if no matching device was found;
+ * 0 if no matching driver was found;
  * -ENODEV if the device is not registered.
  *
  * When called for a USB interface, @dev->parent->sem must be held.
-- 
1.6.3.2

