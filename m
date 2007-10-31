Return-Path: <linux-kernel-owner+w=401wt.eu-S1759698AbXJaPYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759698AbXJaPYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 11:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757433AbXJaPXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 11:23:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33378 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757527AbXJaPXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 11:23:52 -0400
Date: Wed, 31 Oct 2007 08:11:01 -0700
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
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 03/26] Fix cls_u32 error return handling.
Message-ID: <20071031151101.GD2437@kroah.com>
References: <20071031150535.967437651@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-cls_u32-error-return-handling.patch"
In-Reply-To: <20071031151015.GA2437@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Stephen Hemminger <shemminger@linux-foundation.org>

changeset bf1b803b01b00c3801e0aa373ba0305f8278e260 from mainline.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sched/cls_u32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -518,7 +518,7 @@ static int u32_set_parms(struct tcf_prot
 
 #ifdef CONFIG_NET_CLS_IND
 	if (tb[TCA_U32_INDEV-1]) {
-		int err = tcf_change_indev(tp, n->indev, tb[TCA_U32_INDEV-1]);
+		err = tcf_change_indev(tp, n->indev, tb[TCA_U32_INDEV-1]);
 		if (err < 0)
 			goto errout;
 	}

-- 
