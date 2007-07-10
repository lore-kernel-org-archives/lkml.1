Return-Path: <linux-kernel-owner+w=401wt.eu-S1760909AbXGJUHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760909AbXGJUHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 16:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760130AbXGJUH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 16:07:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41649 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759886AbXGJUH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 16:07:28 -0400
Date: Tue, 10 Jul 2007 13:06:53 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.22.1
Message-ID: <20070710200653.GB5881@kroah.com>
References: <20070710200637.GA5881@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710200637.GA5881@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index de4f8f7..e28395a 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 22
-EXTRAVERSION =
+EXTRAVERSION = .1
 NAME = Holy Dancing Manatees, Batman!
 
 # *DOCUMENTATION*
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 0d3254b..6e41ba5 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -460,7 +460,8 @@ static int sctp_new(struct nf_conn *conntrack, const struct sk_buff *skb,
 					 SCTP_CONNTRACK_NONE, sch->type);
 
 		/* Invalid: delete conntrack */
-		if (newconntrack == SCTP_CONNTRACK_MAX) {
+		if (newconntrack == SCTP_CONNTRACK_NONE ||
+		    newconntrack == SCTP_CONNTRACK_MAX) {
 			DEBUGP("nf_conntrack_sctp: invalid new deleting.\n");
 			return 0;
 		}
