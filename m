Return-Path: <linux-kernel-owner+w=401wt.eu-S1763495AbXJOLiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763495AbXJOLiK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 07:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758910AbXJOLh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 07:37:56 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:42807 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757383AbXJOLhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 07:37:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=SUYU/4LweOqpyXUNhVHa7JNefwbIw12mRgFuYR2Rm3PP6f0l8kVCSaYllgqlGw2696mCYRZpGFZZNAazKRRuPvq5bAXS5u0E7FySBVfIYYXzX9oFOn4aSoWNcfci8fMrkOSoCLN6a4tA40IC8S9w4MYaIEn0DjrUjA2BFClAKFk=
Date: Mon, 15 Oct 2007 19:34:45 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: mb@bu3sch.de, st3@riseup.net, Larry.Finger@lwfinger.net,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: [-mm Patch] drivers/net/wireless/b43/main.c: fix an uninitialized
	variable
Message-ID: <20071015113445.GO2444@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20071014175142.GN4211@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071014175142.GN4211@stusta.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Fix an uninitialized variable in drivers/net/wireless/b43/main.c::b43_start().

From: Adrian Bunk <bunk@kernel.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
 drivers/net/wireless/b43/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23-mm1/drivers/net/wireless/b43/main.c
===================================================================
--- linux-2.6.23-mm1.orig/drivers/net/wireless/b43/main.c
+++ linux-2.6.23-mm1/drivers/net/wireless/b43/main.c
@@ -3495,7 +3495,7 @@ static int b43_start(struct ieee80211_hw
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev = wl->current_dev;
 	int did_init = 0;
-	int err;
+	int err = 0;
 
 	mutex_lock(&wl->mutex);
 
