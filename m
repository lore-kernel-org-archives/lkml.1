Return-Path: <linux-kernel-owner+w=401wt.eu-S1762568AbXFJTjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762568AbXFJTjS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 15:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754983AbXFJTjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 15:39:03 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:3939 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785AbXFJTjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 15:39:01 -0400
Date: Sun, 10 Jun 2007 22:39:12 +0300
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>,
       Andrew Morton <akpm@linux-foundation.org>, gregkh@suse.de
Subject: [PATCH trivial] include linux/mutex.h from attribute_container.c
Message-ID: <20070610193912.GA2252@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

attribute_container.c uses DEFINE_MUTEX, so while
linux/mutex.h seems to be pulled in indirectly
by one of the headers it includes, the right thing
is to include linux/mutex.h directly.

Signed-off-by: Michael S. Tsirkin <mst@dev.mellanox.co.il>

---

Does this make sense?

Index: ofed_kernel/drivers/base/attribute_container.c
===================================================================
--- ofed_kernel.orig/drivers/base/attribute_container.c	2007-05-29 14:49:57.000000000 +0300
+++ ofed_kernel/drivers/base/attribute_container.c	2007-06-10 21:29:36.000000000 +0300
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 
 #include "base.h"
 

-- 
MST
