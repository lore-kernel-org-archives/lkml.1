Return-Path: <linux-kernel-owner+w=401wt.eu-S1764004AbYEUIkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764004AbYEUIkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 04:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756683AbYEUIkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 04:40:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756842AbYEUIke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 04:40:34 -0400
To: linux-kernel@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
       linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
       linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       mingo@redhat.com, akpm@linux-foundation.org,
       Pat Campbell <plc@novell.com>
Subject: [PATCH 3/5] xen pvfb: Module aliases to support module autoloading
References: <87d4ngm4s4.fsf@pike.pond.sub.org>
From: Markus Armbruster <armbru@redhat.com>
Date: Wed, 21 May 2008 10:40:18 +0200
Message-ID: <873aocm4nh.fsf@pike.pond.sub.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are mostly for completeness and consistency with the other
frontends, as PVFB is typically compiled in rather than a module.

Derived from
http://xenbits.xensource.com/linux-2.6.18-xen.hg?rev/5e294e29a43e

While there, add module descriptions.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 drivers/input/xen-kbdfront.c |    2 ++
 drivers/video/xen-fbfront.c  |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/input/xen-kbdfront.c b/drivers/input/xen-kbdfront.c
index 9da4452..eaf69cf 100644
--- a/drivers/input/xen-kbdfront.c
+++ b/drivers/input/xen-kbdfront.c
@@ -343,4 +343,6 @@ static void __exit xenkbd_cleanup(void)
 module_init(xenkbd_init);
 module_exit(xenkbd_cleanup);
 
+MODULE_DESCRIPTION("Xen virtual keyboard/pointer device frontend");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("xen:vkbd");
diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
index 4e10876..5553e51 100644
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -572,4 +572,6 @@ static void __exit xenfb_cleanup(void)
 module_init(xenfb_init);
 module_exit(xenfb_cleanup);
 
+MODULE_DESCRIPTION("Xen virtual framebuffer device frontend");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("xen:vfb");
-- 
1.5.3.3

