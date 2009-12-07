Return-Path: <linux-kernel-owner+w=401wt.eu-S1758583AbZLGAWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583AbZLGAWs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758519AbZLGANk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:13:40 -0500
Received: from kroah.org ([198.145.64.141]:34561 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758526AbZLGANb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:31 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:53 2009
Message-Id: <20091207000653.567571821@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jamal Hadi Salim <hadi@cyberus.ca>,
       "David S. Miller" <davem@davemloft.net>
Subject: [074/119] pkt_sched: pedit use proper struct
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=pkt_sched-pedit-use-proper-struct.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jamal Hadi Salim <hadi@cyberus.ca>

[ Upstream commit 53f7e35f8b7fc2f5620a863ac613bcf3080cb6ba ]

This probably deserves to go into -stable.

Pedit will reject a policy that is large because it
uses the wrong structure in the policy validation.
This fixes it.

Signed-off-by: Jamal Hadi Salim <hadi@cyberus.ca>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sched/act_pedit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -34,7 +34,7 @@ static struct tcf_hashinfo pedit_hash_in
 };
 
 static const struct nla_policy pedit_policy[TCA_PEDIT_MAX + 1] = {
-	[TCA_PEDIT_PARMS]	= { .len = sizeof(struct tcf_pedit) },
+	[TCA_PEDIT_PARMS]	= { .len = sizeof(struct tc_pedit) },
 };
 
 static int tcf_pedit_init(struct nlattr *nla, struct nlattr *est,


