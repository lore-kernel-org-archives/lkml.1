Return-Path: <linux-kernel-owner+w=401wt.eu-S1757082AbZFRRow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082AbZFRRow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 13:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756547AbZFRRo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 13:44:28 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:36251 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485AbZFRRoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 13:44:25 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH 1/4] KVM: update inaccurate irqfd comment
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, davidel@xmailserver.org, mingo@elte.hu,
       mst@redhat.com, avi@redhat.com, paulmck@linux.vnet.ibm.com,
       rusty@rustcorp.com.au
Date: Thu, 18 Jun 2009 13:44:16 -0400
Message-ID: <20090618174416.24119.20906.stgit@dev.haskins.net>
In-Reply-To: <20090618173534.24119.95115.stgit@dev.haskins.net>
References: <20090618173534.24119.95115.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We no longer hold the fget() for the irqfd lifetime, so clean up the comments
related to that.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 virt/kvm/eventfd.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 2c8028c..a0e329f 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -156,9 +156,6 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
 	INIT_LIST_HEAD(&irqfd->list);
 	INIT_WORK(&irqfd->inject, irqfd_inject);
 
-	/*
-	 * Embed the file* lifetime in the irqfd.
-	 */
 	file = eventfd_fget(fd);
 	if (IS_ERR(file)) {
 		ret = PTR_ERR(file);

