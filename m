Return-Path: <linux-kernel-owner+w=401wt.eu-S1765082AbYBCABY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765082AbYBCABY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 19:01:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765562AbYBBX60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 18:58:26 -0500
Received: from cantor.suse.de ([195.135.220.2]:37548 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765477AbYBBX6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 18:58:25 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/10] Driver core: Update some prototypes in platform.txt
Date: Sat,  2 Feb 2008 15:56:03 -0800
Message-Id: <1201996564-21951-9-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080202234357.GA21721@suse.de>
References: <20080202234357.GA21721@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>

Just make these match the actual code.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/driver-model/platform.txt |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/driver-model/platform.txt b/Documentation/driver-model/platform.txt
index 2a97320..83009fd 100644
--- a/Documentation/driver-model/platform.txt
+++ b/Documentation/driver-model/platform.txt
@@ -122,15 +122,15 @@ None the less, there are some APIs to support such legacy drivers.  Avoid
 using these calls except with such hotplug-deficient drivers.
 
 	struct platform_device *platform_device_alloc(
-			char *name, unsigned id);
+			const char *name, int id);
 
 You can use platform_device_alloc() to dynamically allocate a device, which
 you will then initialize with resources and platform_device_register().
 A better solution is usually:
 
 	struct platform_device *platform_device_register_simple(
-			char *name, unsigned id,
-			struct resource *res, unsigned nres);
+			const char *name, int id,
+			struct resource *res, unsigned int nres);
 
 You can use platform_device_register_simple() as a one-step call to allocate
 and register a device.
-- 
1.5.3.8

