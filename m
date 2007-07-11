Return-Path: <linux-kernel-owner+w=401wt.eu-S932212AbXGKUkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212AbXGKUkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 16:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758560AbXGKUkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 16:40:23 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54002 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759312AbXGKUkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 16:40:21 -0400
Subject: [PATCH] relay: fix subbuf_splice_actor() comment
From: Tom Zanussi <zanussi@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, jens.axboe@oracle.com, dwilder@us.ibm.com
Content-Type: text/plain
Date: Wed, 11 Jul 2007 15:36:29 -0500
Message-Id: <1184186189.4517.35.camel@ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Change comment from kerneldoc to normal.

Signed-off-by: Tom Zanussi <zanussi@us.ibm.com>

---
 relay.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/relay.c b/kernel/relay.c
index 7802697..a615a8f 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -1061,7 +1061,7 @@ static struct pipe_buf_operations relay_pipe_buf_ops = {
 	.get = generic_pipe_buf_get,
 };
 
-/**
+/*
  *	subbuf_splice_actor - splice up to one subbuf's worth of data
  */
 static int subbuf_splice_actor(struct file *in,



