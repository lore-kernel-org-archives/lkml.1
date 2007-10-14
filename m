Return-Path: <linux-kernel-owner+w=401wt.eu-S1759553AbXJNSXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759553AbXJNSXQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 14:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758405AbXJNSXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 14:23:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45639 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758436AbXJNSXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 14:23:03 -0400
Date: Sun, 14 Oct 2007 19:22:59 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: shemminger@linux-foundation.org, jgarzik@pobox.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] remove duplicate initializer (macvlan)
Message-ID: <20071014182259.GY8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/macvlan.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index b7c81c8..2e4bcd5 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -178,7 +178,6 @@ static const struct header_ops macvlan_hard_header_ops = {
 	.create  	= macvlan_hard_header,
 	.rebuild	= eth_rebuild_header,
 	.parse		= eth_header_parse,
-	.rebuild	= eth_rebuild_header,
 	.cache		= eth_header_cache,
 	.cache_update	= eth_header_cache_update,
 };
-- 
1.5.3.GIT

