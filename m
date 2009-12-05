Return-Path: <linux-kernel-owner+w=401wt.eu-S932616AbZLEABB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616AbZLEABB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 19:01:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932571AbZLEABA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 19:01:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34096 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932569AbZLEAA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 19:00:59 -0500
Message-ID: <4B19A32F.5020207@gmail.com>
Date: Sat, 05 Dec 2009 01:02:55 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: davem@davemloft.net, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 22/31] Constify struct neigh_ops for 2.6.32 v1
References: <4B198670.2000406@gmail.com> <4B198FA1.7090807@gmail.com>
In-Reply-To: <4B198FA1.7090807@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>

Constify struct neigh_ops.
Per Dave Miller's suggestion, resend with proper CC list and patch format.

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

