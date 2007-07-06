Return-Path: <linux-kernel-owner+w=401wt.eu-S1763120AbXGFMsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763120AbXGFMsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 08:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760194AbXGFMsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 08:48:37 -0400
Received: from mail.macqel.be ([194.78.208.39]:12166 "EHLO mail.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760176AbXGFMsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 08:48:37 -0400
Date: Fri, 6 Jul 2007 14:48:29 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] net : make netlink_seq_ops const
Message-ID: <20070706124829.GA12930@muff.macqel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Make netlink_seq_ops const

Signed-off-by: Philippe De Muyter <phdm@macqel.be>

diff -r 6c0a10cc415a net/netlink/af_netlink.c
--- a/net/netlink/af_netlink.c	Thu Jul  5 16:10:16 2007 -0700
+++ b/net/netlink/af_netlink.c	Fri Jul  6 14:43:30 2007 +0200
@@ -1713,7 +1713,7 @@ static int netlink_seq_show(struct seq_f
 	return 0;
 }
 
-static struct seq_operations netlink_seq_ops = {
+static const struct seq_operations netlink_seq_ops = {
 	.start  = netlink_seq_start,
 	.next   = netlink_seq_next,
 	.stop   = netlink_seq_stop,
