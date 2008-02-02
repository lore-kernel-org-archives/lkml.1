Return-Path: <linux-kernel-owner+w=401wt.eu-S1758011AbYBBLPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011AbYBBLPV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 06:15:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754954AbYBBLPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 06:15:08 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:34727 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754751AbYBBLPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 06:15:06 -0500
Date: Sat, 2 Feb 2008 22:15:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Update some prototypes in platform.txt
Message-Id: <20080202221507.fd916a3b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just make these match the actual code.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
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

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
