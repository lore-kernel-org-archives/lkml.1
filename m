Return-Path: <linux-kernel-owner+w=401wt.eu-S1755797AbYEWNKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797AbYEWNKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbYEWNJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:09:23 -0400
Received: from gw.goop.org ([64.81.55.164]:33891 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253AbYEWNJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:09:21 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 3 of 5] xen pvfb: Module aliases to support module autoloading
X-Mercurial-Node: e4f9a59f37c7bfc8de8f4f5b294f41096f6b1d76
Message-Id: <e4f9a59f37c7bfc8de8f.1211547983@localhost>
In-Reply-To: <patchbomb.1211547980@localhost>
Date: Fri, 23 May 2008 14:06:23 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Markus Armbruster <armbru@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Armbruster <armbru@redhat.com>

These are mostly for completeness and consistency with the other
frontends, as PVFB is typically compiled in rather than a module.

Derived from
http://xenbits.xensource.com/linux-2.6.18-xen.hg?rev/5e294e29a43e

While there, add module descriptions.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/input/xen-kbdfront.c |    2 ++
 drivers/video/xen-fbfront.c  |    3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/input/xen-kbdfront.c b/drivers/input/xen-kbdfront.c
--- a/drivers/input/xen-kbdfront.c
+++ b/drivers/input/xen-kbdfront.c
@@ -343,4 +343,6 @@
 module_init(xenkbd_init);
 module_exit(xenkbd_cleanup);
 
+MODULE_DESCRIPTION("Xen virtual keyboard/pointer device frontend");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("xen:vkbd");
diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -572,4 +572,6 @@
 module_init(xenfb_init);
 module_exit(xenfb_cleanup);
 
+MODULE_DESCRIPTION("Xen virtual framebuffer device frontend");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("xen:vfb");


