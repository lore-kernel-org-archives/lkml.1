Return-Path: <linux-kernel-owner+w=401wt.eu-S1758679AbYE2SVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679AbYE2SVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:21:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756882AbYE2STz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:19:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756644AbYE2STy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:19:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/6] Werror: Hide epca_setup() as it's unused
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, bunk@kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 29 May 2008 19:17:31 +0100
Message-ID: <20080529181731.5396.42286.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080529181726.5396.79336.stgit@warthog.procyon.org.uk>
References: <20080529181726.5396.79336.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hide epca_setup() by encasing it in #if 0 as it's unused.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/char/epca.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)


diff --git a/drivers/char/epca.c b/drivers/char/epca.c
index 60a4df7..0d3f685 100644
--- a/drivers/char/epca.c
+++ b/drivers/char/epca.c
@@ -186,7 +186,9 @@ static void pc_throttle(struct tty_struct *tty);
 static void pc_unthrottle(struct tty_struct *tty);
 static void digi_send_break(struct channel *ch, int msec);
 static void setup_empty_event(struct tty_struct *tty, struct channel *ch);
+#if 0 // UNUSED
 static void epca_setup(char *, int *);
+#endif
 
 static int pc_write(struct tty_struct *, const unsigned char *, int);
 static int pc_init(void);
@@ -2538,6 +2540,7 @@ static void setup_empty_event(struct tty_struct *tty, struct channel *ch)
 	memoff(ch);
 }
 
+#if 0 // UNUSED
 static void epca_setup(char *str, int *ints)
 {
 	struct board_info board;
@@ -2791,6 +2794,7 @@ static void epca_setup(char *str, int *ints)
 		board.numports, (int)board.port, (unsigned int) board.membase);
 	num_cards++;
 }
+#endif
 
 enum epic_board_types {
 	brd_xr = 0,

