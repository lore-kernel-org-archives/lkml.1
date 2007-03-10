Return-Path: <linux-kernel-owner+w=401wt.eu-S1750948AbXCJGV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750948AbXCJGV4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 01:21:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750978AbXCJGVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 01:21:19 -0500
Received: from mx1.suse.de ([195.135.220.2]:41156 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbXCJGUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 01:20:42 -0500
Date: Fri, 9 Mar 2007 22:18:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       Eric Dumazet <dada1@cosmosbay.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 19/20] Fix timewait jiffies
Message-ID: <20070310061859.GT31412@kroah.com>
References: <20070310061234.465093436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-timewait-jiffies.patch"
In-Reply-To: <20070310061603.GA31412@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Eric Dumazet <dada1@cosmosbay.com>

[INET]: twcal_jiffie should be unsigned long, not int

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/net/inet_timewait_sock.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/net/inet_timewait_sock.h
+++ b/include/net/inet_timewait_sock.h
@@ -66,7 +66,7 @@ struct inet_hashinfo;
 struct inet_timewait_death_row {
 	/* Short-time timewait calendar */
 	int			twcal_hand;
-	int			twcal_jiffie;
+	unsigned long		twcal_jiffie;
 	struct timer_list	twcal_timer;
 	struct hlist_head	twcal_row[INET_TWDR_RECYCLE_SLOTS];
 

-- 
