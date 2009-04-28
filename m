Return-Path: <linux-kernel-owner+w=401wt.eu-S1762096AbZD1PrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762096AbZD1PrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 11:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760910AbZD1Pq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 11:46:57 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:18616 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664AbZD1Pq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 11:46:57 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] virtio: add missing include to virtio_net.h
To: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Date: Tue, 28 Apr 2009 09:46:54 -0600
Message-ID: <20090428154654.19053.92829.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

virtio_net.h uses the macro ETH_ALEN which is defined in linux/if_ether.h.
Discovered when hacking on virtio-over-pci patches.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 include/linux/virtio_net.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index 242348b..cec79ad 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -4,6 +4,7 @@
  * compatible drivers/servers. */
 #include <linux/types.h>
 #include <linux/virtio_config.h>
+#include <linux/if_ether.h>
 
 /* The ID for virtio_net */
 #define VIRTIO_ID_NET	1

