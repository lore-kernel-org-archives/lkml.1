Return-Path: <linux-kernel-owner+w=401wt.eu-S1753647AbZLWBqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbZLWBqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 20:46:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbZLWBpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 20:45:54 -0500
Received: from ozlabs.org ([203.10.76.45]:38940 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903AbZLWBpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 20:45:45 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 3/3] proc_devtree: include linux/of.h
Message-Id: <1261532718.576015.537671965190.3.gpush@pororo>
In-Reply-To: <1261532718.575048.365032094903.0.gpush@pororo>
To: Grant Likely <grant.likely@secretlab.ca>,
       devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
From: Jeremy Kerr <jeremy.kerr@canonical.com>
Date: Wed, 23 Dec 2009 09:45:18 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currenly, proc_devtree.c depends on asm/prom.h to include linux/of.h, to
provide some device-tree definitions (eg, struct property).

Instead, include linux/of.h directly. We still need asm/prom.h for
HAVE_ARCH_DEVTREE_FIXUPS.

Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>

---
 fs/proc/proc_devtree.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/proc/proc_devtree.c b/fs/proc/proc_devtree.c
index 31fc7e0..2ea10dd 100644
--- a/fs/proc/proc_devtree.c
+++ b/fs/proc/proc_devtree.c
@@ -9,6 +9,7 @@
 #include <linux/proc_fs.h>
 #include <linux/stat.h>
 #include <linux/string.h>
+#include <linux/of.h>
 #include <asm/prom.h>
 #include <asm/uaccess.h>
 #include "internal.h"
