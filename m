Return-Path: <linux-kernel-owner+w=401wt.eu-S1757524AbZLDWhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbZLDWhj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:37:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757459AbZLDWhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:37:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55761 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757426AbZLDWhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:37:37 -0500
Message-ID: <4B198FA1.7090807@gmail.com>
Date: Fri, 04 Dec 2009 23:39:29 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: davem@davemloft.net, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 22/31] Constify struct neigh_ops for 2.6.32 v1
References: <4B198670.2000406@gmail.com>
In-Reply-To: <4B198670.2000406@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>

Constify struct neigh_ops.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 include/net/neighbour.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 3817fda..2c61d38 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -125,12 +125,12 @@ struct neighbour
 struct neigh_ops
 {
 	int			family;
-	void			(*solicit)(struct neighbour *, struct sk_buff*);
-	void			(*error_report)(struct neighbour *, struct sk_buff*);
-	int			(*output)(struct sk_buff*);
-	int			(*connected_output)(struct sk_buff*);
-	int			(*hh_output)(struct sk_buff*);
-	int			(*queue_xmit)(struct sk_buff*);
+	void			(* const solicit)(struct neighbour *, struct sk_buff*);
+	void			(* const error_report)(struct neighbour *, struct sk_buff*);
+	int			(* const output)(struct sk_buff*);
+	int			(* const connected_output)(struct sk_buff*);
+	int			(* const hh_output)(struct sk_buff*);
+	int			(* const queue_xmit)(struct sk_buff*);
 };
 
 struct pneigh_entry

