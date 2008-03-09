Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbYCIX4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbYCIX4t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 19:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755179AbYCIX4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 19:56:20 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:4365 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755145AbYCIX4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 19:56:19 -0400
Subject: [PATCH] include/linux/atalk.h - remove duplicate include
From: Joe Perches <joe@perches.com>
To: netdev <netdev@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 09 Mar 2008 16:55:20 -0700
Message-Id: <1205106920.656.101.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>

 include/linux/atalk.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/atalk.h b/include/linux/atalk.h
index ced8a1e..e9ebac2 100644
--- a/include/linux/atalk.h
+++ b/include/linux/atalk.h
@@ -85,8 +85,6 @@ static inline struct atalk_sock *at_sk(struct sock *sk)
 	return (struct atalk_sock *)sk;
 }
 
-#include <asm/byteorder.h>
-
 struct ddpehdr {
 	__be16	deh_len_hops;	/* lower 10 bits are length, next 4 - hops */
 	__be16	deh_sum;


