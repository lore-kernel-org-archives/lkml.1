Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbXLETZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbXLETZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 14:25:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbXLETZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 14:25:40 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:23196 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbXLETZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 14:25:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:from:to:cc:subject:date:message-id:x-mailer;
        b=AJdeMHCIa7bywWxhCLCdOjqm0JKkhUCgHbQ+GLuiGOnXrx+oPQKLuF9ZVBk3cK9T/R4uUkB3OEqWt0pNGJHyb8A+0pcTcZO/D6IQ0NwtmdrNJASvvfjifPGmwd//3M07hxJzIJrJE5NbEV7nDmH6iz+1xDVLbQxPxf24uB4ribY=
From: Denis Cheng <crquan@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 08/20] drivers/net/wan/lapbether.c: use LIST_HEAD instead of LIST_HEAD_INIT
Date: Thu,  6 Dec 2007 03:23:53 +0800
Message-Id: <1196882633-18880-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

single list_head variable initialized with LIST_HEAD_INIT could almost
always can be replaced with LIST_HEAD declaration, this shrinks the code
and looks better.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 drivers/net/wan/lapbether.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index fb37b80..824df3b 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -58,7 +58,7 @@ struct lapbethdev {
 	struct net_device_stats stats;		/* some statistics */
 };
 
-static struct list_head lapbeth_devices = LIST_HEAD_INIT(lapbeth_devices);
+static LIST_HEAD(lapbeth_devices);
 
 /* ------------------------------------------------------------------------ */
 
-- 
1.5.3.4

