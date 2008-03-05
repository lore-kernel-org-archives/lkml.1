Return-Path: <linux-kernel-owner+w=401wt.eu-S935703AbYCEBWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935703AbYCEBWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 20:22:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764341AbYCEBR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 20:17:58 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:52775 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763521AbYCEBRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 20:17:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YrW/mrDm7AgmiIfpxsta1r3JE4o6mRyVR6mzyywW2WZk7MMqz8DGk7EqGWbn4ZiJ1JB8Td/Pq75U5L138IlTaOd1sho0l0hqlRfuxQZAlC52QPAe2w22hh34dFptm+oDfihDt+kmYclyyW3RFSuBmtsa3egTBXqDzFg2bp58UXc=
Subject: [PATCH 9/9] irda: replace __inline with inline
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 17:17:20 -0800
Message-Id: <1204679841.5698.75.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/net/irda/irttp.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/irda/irttp.h b/include/net/irda/irttp.h
index 32c385d..0788c23 100644
--- a/include/net/irda/irttp.h
+++ b/include/net/irda/irttp.h
@@ -169,17 +169,17 @@ int irttp_disconnect_request(struct tsap_cb *self, struct sk_buff *skb,
 void irttp_flow_request(struct tsap_cb *self, LOCAL_FLOW flow);
 struct tsap_cb *irttp_dup(struct tsap_cb *self, void *instance);
 
-static __inline __u32 irttp_get_saddr(struct tsap_cb *self)
+static inline __u32 irttp_get_saddr(struct tsap_cb *self)
 {
 	return irlmp_get_saddr(self->lsap);
 }
 
-static __inline __u32 irttp_get_daddr(struct tsap_cb *self)
+static inline __u32 irttp_get_daddr(struct tsap_cb *self)
 {
 	return irlmp_get_daddr(self->lsap);
 }
 
-static __inline __u32 irttp_get_max_seg_size(struct tsap_cb *self)
+static inline __u32 irttp_get_max_seg_size(struct tsap_cb *self)
 {
 	return self->max_seg_size;
 }
-- 
1.5.4.3.500.g83a2c

