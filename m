Return-Path: <linux-kernel-owner+w=401wt.eu-S1762604AbXIXQiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762604AbXIXQiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760271AbXIXQ1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:27:25 -0400
Received: from canuck.infradead.org ([209.217.80.40]:57992 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760305AbXIXQ1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:27:23 -0400
Date: Mon, 24 Sep 2007 09:21:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>
Subject: [35/50] Fix decnet device address listing.
Message-ID: <20070924162159.GJ13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-decnet-device-address-listing.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Patrick McHardy <kaber@trash.net>

commit a2221f308dabb95abb914ad858d36c2462705558 in mainline.

Not all are listed, same as the IPV4 devinet bug.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/decnet/dn_dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/decnet/dn_dev.c
+++ b/net/decnet/dn_dev.c
@@ -815,7 +815,7 @@ static int dn_nl_dump_ifaddr(struct sk_b
 		for (ifa = dn_db->ifa_list, dn_idx = 0; ifa;
 		     ifa = ifa->ifa_next, dn_idx++) {
 			if (dn_idx < skip_naddr)
-				goto cont;
+				continue;
 
 			if (dn_nl_fill_ifaddr(skb, ifa, NETLINK_CB(cb->skb).pid,
 					      cb->nlh->nlmsg_seq, RTM_NEWADDR,

-- 
