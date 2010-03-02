Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179Ab0CBXzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:55:10 -0500
Received: from kroah.org ([198.145.64.141]:38552 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754229Ab0CBX3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:24 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 23/62] driver-core: firmware_class: remove base.h header inclusion
Date: Tue,  2 Mar 2010 15:28:22 -0800
Message-Id: <1267572541-410-23-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luis R. Rodriguez <lrodriguez@atheros.com>

base.h is used by base drivers for sharing internal structures.
Turns out firmware_class does not depend on it at all so remove it.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/firmware_class.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 6604fb3..0797748 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -19,7 +19,6 @@
 #include <linux/kthread.h>
 #include <linux/highmem.h>
 #include <linux/firmware.h>
-#include "base.h"
 
 #define to_dev(obj) container_of(obj, struct device, kobj)
 
-- 
1.7.0.1

