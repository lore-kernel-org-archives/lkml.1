Return-Path: <linux-kernel-owner+w=401wt.eu-S1758558AbXHSDvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558AbXHSDvh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 23:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756616AbXHSDv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 23:51:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51676 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516AbXHSDv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 23:51:27 -0400
Date: Sun, 19 Aug 2007 04:51:26 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: shemminger@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] missing return in bridge sysfs code
Message-ID: <20070819035126.GS21089@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
index 88f4300..c65f54e 100644
--- a/net/bridge/br_sysfs_br.c
+++ b/net/bridge/br_sysfs_br.c
@@ -167,6 +167,7 @@ static ssize_t store_stp_state(struct device *d,
 	br_stp_set_enabled(br, val);
 	rtnl_unlock();
 
+	return len;
 }
 static DEVICE_ATTR(stp_state, S_IRUGO | S_IWUSR, show_stp_state,
 		   store_stp_state);
