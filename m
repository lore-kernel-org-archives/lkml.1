Return-Path: <linux-kernel-owner+w=401wt.eu-S1759570AbYGPPax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759570AbYGPPax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 11:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756741AbYGPPao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 11:30:44 -0400
Received: from multi.imgtec.com ([194.200.65.239]:41164 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756499AbYGPPao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 11:30:44 -0400
From: Will Newton <will.newton@imgtec.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Will Newton <will.newton@gmail.com>
Subject: [PATCH] net/ipv4/tcp.c: Fix use of PULLHUP instead of POLLHUP in comments.
Date: Wed, 16 Jul 2008 16:30:35 +0100
Message-Id: <1216222235-11338-1-git-send-email-will.newton@imgtec.com>
X-Mailer: git-send-email 1.5.5.2
X-OriginalArrivalTime: 16 Jul 2008 15:30:42.0168 (UTC) FILETIME=[E85E1F80:01C8E758]
X-SEF-Processed: 6_0_1_111__2008_07_16_16_30_42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Newton <will.newton@gmail.com>

Change PULLHUP to POLLHUP in tcp_poll comments and clean up another
comment for grammar and coding style.

Signed-off-by: Will Newton <will.newton@gmail.com>
---
 net/ipv4/tcp.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 1d723de..b343ce3 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -346,8 +346,8 @@ unsigned int tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 		return inet_csk_listen_poll(sk);
 
 	/* Socket is not locked. We are protected from async events
-	   by poll logic and correct handling of state changes
-	   made by another threads is impossible in any case.
+	 * by poll logic and correct handling of state changes
+	 * made by other threads is impossible in any case.
 	 */
 
 	mask = 0;
@@ -373,10 +373,10 @@ unsigned int tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 	 * in state CLOSE_WAIT. One solution is evident --- to set POLLHUP
 	 * if and only if shutdown has been made in both directions.
 	 * Actually, it is interesting to look how Solaris and DUX
-	 * solve this dilemma. I would prefer, if PULLHUP were maskable,
+	 * solve this dilemma. I would prefer, if POLLHUP were maskable,
 	 * then we could set it on SND_SHUTDOWN. BTW examples given
 	 * in Stevens' books assume exactly this behaviour, it explains
-	 * why PULLHUP is incompatible with POLLOUT.	--ANK
+	 * why POLLHUP is incompatible with POLLOUT.	--ANK
 	 *
 	 * NOTE. Check for TCP_CLOSE is added. The goal is to prevent
 	 * blocking on fresh not-connected or disconnected socket. --ANK
-- 
1.5.5.2

