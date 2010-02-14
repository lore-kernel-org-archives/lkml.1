Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758391Ab0BNLFj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 06:05:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758336Ab0BNLFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 06:05:32 -0500
Date: Sun, 14 Feb 2010 13:01:00 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "Michael S. Tsirkin" <mst@redhat.com>, Paul Moore <paul.moore@hp.com>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Sridhar Samudrala <sri@us.ibm.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] net: export attach/detach filter routines
Message-ID: <20100214110100.GB30182@redhat.com>
References: <cover.1266144917.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1266144917.git.mst@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export sk_attach_filter/sk_detach_filter routines,
so that tun module can use them.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 net/core/filter.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 4e0712a..08e40f3 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -530,6 +530,7 @@ int sk_attach_filter(struct sock_fprog *fprog, struct sock *sk)
 		sk_filter_delayed_uncharge(sk, old_fp);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(sk_attach_filter);
 
 int sk_detach_filter(struct sock *sk)
 {
@@ -546,3 +547,4 @@ int sk_detach_filter(struct sock *sk)
 	rcu_read_unlock_bh();
 	return ret;
 }
+EXPORT_SYMBOL_GPL(sk_detach_filter);
-- 
1.6.6.144.g5c3af

