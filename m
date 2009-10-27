Return-Path: <linux-kernel-owner+w=401wt.eu-S1752020AbZJ0OLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020AbZJ0OLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 10:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbZJ0OLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 10:11:48 -0400
Received: from mail-forward1.uio.no ([129.240.10.70]:40958 "EHLO
	mail-forward1.uio.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbZJ0OLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 10:11:48 -0400
X-Greylist: delayed 2248 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Oct 2009 10:11:48 EDT
Message-ID: <4AE6F539.1020107@simula.no>
Date: Tue, 27 Oct 2009 14:27:21 +0100
From: Andreas Petlund <apetlund@simula.no>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: netdev@vger.kernel.org
CC: trivial@kernel.org, linux-kernel@vger.kernel.org,
       ilpo.jarvinen@helsinki.fi
Subject: [PATCH] net: Corrected spelling error heurestics->heuristics
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 4 msgs/h 1 sum rcpts/h 6 sum msgs/h 3 total rcpts 334 max rcpts/h 20 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: D8BBEB4ACF55811E34684AFBAF5CADB838B1816A
X-UiO-SPAM-Test: remote_host: 128.39.37.254 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 10 total 4063 max/h 42 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrected a spelling error in a function name.

Signed-off-by: Andreas Petlund <apetlund@simula.no>
---
 net/ipv4/tcp_input.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index d86784b..a0c3700 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2300,7 +2300,7 @@ static inline int tcp_fackets_out(struct tcp_sock *tp)
  * they differ. Since neither occurs due to loss, TCP should really
  * ignore them.
  */
-static inline int tcp_dupack_heurestics(struct tcp_sock *tp)
+static inline int tcp_dupack_heuristics(struct tcp_sock *tp)
 {
 	return tcp_is_fack(tp) ? tp->fackets_out : tp->sacked_out + 1;
 }
@@ -2425,7 +2425,7 @@ static int tcp_time_to_recover(struct sock *sk)
 		return 1;
 
 	/* Not-A-Trick#2 : Classic rule... */
-	if (tcp_dupack_heurestics(tp) > tp->reordering)
+	if (tcp_dupack_heuristics(tp) > tp->reordering)
 		return 1;
 
 	/* Trick#3 : when we use RFC2988 timer restart, fast
-- 
1.6.0.4

