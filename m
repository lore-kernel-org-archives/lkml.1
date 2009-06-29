Return-Path: <linux-kernel-owner+w=401wt.eu-S1758777AbZF2Rgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777AbZF2Rgb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 13:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754559AbZF2Rf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 13:35:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39865 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757990AbZF2RfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 13:35:20 -0400
Date: Mon, 29 Jun 2009 20:34:49 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>, avi@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: [PATCHv4 6/6] kvm: document lock nesting rule
Message-ID: <20090629173449.GG22855@redhat.com>
References: <cover.1246294571.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1246294571.git.mst@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document kvm->lock nesting within kvm->slots_lock

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 virt/kvm/kvm_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 728118f..afbf006 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -68,7 +68,7 @@ MODULE_LICENSE("GPL");
 /*
  * Ordering of locks:
  *
- * 		kvm->lock --> kvm->irq_lock
+ * 		kvm->slots_lock --> kvm->lock --> kvm->irq_lock
  */
 
 DEFINE_SPINLOCK(kvm_lock);
-- 
1.6.2.2
