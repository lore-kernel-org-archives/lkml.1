Return-Path: <linux-kernel-owner+w=401wt.eu-S935339AbXGKXh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935339AbXGKXh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934877AbXGKXdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:33:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:33673 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935049AbXGKXdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:33:39 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Subject: [PATCH 10/61] Driver core: include linux/mutex.h from attribute_container.c
Date: Wed, 11 Jul 2007 16:31:29 -0700
Message-Id: <1184196787247-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <1184196783245-git-send-email-gregkh@suse.de>
References: <20070711233021.GA5253@kroah.com>
 <11841967403365-git-send-email-gregkh@suse.de>
 <11841967493890-git-send-email-gregkh@suse.de>
 <1184196753488-git-send-email-gregkh@suse.de>
 <1184196759393-git-send-email-gregkh@suse.de>
 <11841967633087-git-send-email-gregkh@suse.de>
 <11841967674155-git-send-email-gregkh@suse.de>
 <11841967711788-git-send-email-gregkh@suse.de>
 <11841967793134-git-send-email-gregkh@suse.de>
 <1184196783245-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael S. Tsirkin <mst@dev.mellanox.co.il>

attribute_container.c uses DEFINE_MUTEX, so while
linux/mutex.h seems to be pulled in indirectly
by one of the headers it includes, the right thing
is to include linux/mutex.h directly.

Signed-off-by: Michael S. Tsirkin <mst@dev.mellanox.co.il>
---
 drivers/base/attribute_container.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/base/attribute_container.c b/drivers/base/attribute_container.c
index 1ec0654..7370d7c 100644
--- a/drivers/base/attribute_container.c
+++ b/drivers/base/attribute_container.c
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 
 #include "base.h"
 
-- 
1.5.2.2

