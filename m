Return-Path: <linux-kernel-owner+w=401wt.eu-S1760057AbZKFWJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760057AbZKFWJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:09:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759962AbZKFWI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:08:57 -0500
Received: from kroah.org ([198.145.64.141]:39779 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759900AbZKFWFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:05:55 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 13:59:52 2009
Message-Id: <20091106215952.357515032@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 13:56:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jiri Pirko <jpirko@redhat.com>, "David S. Miller" <davem@davemloft.net>,
       Chuck Ebbert <cebbert@redhat.com>
Subject: [18/30] netlink: fix typo in initialization (CVE-2009-3612)
References: <20091106215603.413650799@mini.kroah.org>
Content-Disposition: inline; filename=netlink-fix-typo-in-initialization-cve-2009-3612.patch
In-Reply-To: <20091106220156.GA13813@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jiri Pirko <jpirko@redhat.com>

commit ad61df918c44316940404891d5082c63e79c256a upstream.

Commit 9ef1d4c7c7aca1cd436612b6ca785b726ffb8ed8 ("[NETLINK]: Missing
initializations in dumped data") introduced a typo in
initialization. This patch fixes this.

Signed-off-by: Jiri Pirko <jpirko@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sched/cls_api.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -337,7 +337,7 @@ static int tcf_fill_node(struct sk_buff 
 	tcm = NLMSG_DATA(nlh);
 	tcm->tcm_family = AF_UNSPEC;
 	tcm->tcm__pad1 = 0;
-	tcm->tcm__pad1 = 0;
+	tcm->tcm__pad2 = 0;
 	tcm->tcm_ifindex = qdisc_dev(tp->q)->ifindex;
 	tcm->tcm_parent = tp->classid;
 	tcm->tcm_info = TC_H_MAKE(tp->prio, tp->protocol);


