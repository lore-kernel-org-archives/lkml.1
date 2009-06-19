Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbZFSWWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbZFSWWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 18:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbZFSWWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 18:22:45 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54660 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbZFSWWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 18:22:45 -0400
Date: Sat, 20 Jun 2009 00:22:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: penberg@cs.helsinki.fi, Greg KH <greg@kroah.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: staging: w35und: fix compilation
Message-ID: <20090619222241.GA2304@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


config_interface was removed in 2.6.30, remove it from w35und, too, to
fix compilation.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

---
commit dd28ea7e716406f9c2e8c57866eff92b0cff04a1
tree a45925fc0294d7928833d1a8969741431892597f
parent 22f05b72219e0b6e9f7cf56c3580ad6c9fe66515
author Pavel <pavel@ucw.cz> Sat, 20 Jun 2009 00:21:29 +0200
committer Pavel <pavel@ucw.cz> Sat, 20 Jun 2009 00:21:29 +0200

 drivers/staging/winbond/wbusb.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 3b2d528..87d6c62 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -167,14 +167,6 @@ static int wbsoft_config(struct ieee80211_hw *dev, u32 changed)
 	return 0;
 }
 
-static int wbsoft_config_interface(struct ieee80211_hw *dev,
-				    struct ieee80211_vif *vif,
-				    struct ieee80211_if_conf *conf)
-{
-	printk("wbsoft_config_interface called\n");
-	return 0;
-}
-
 static u64 wbsoft_get_tsf(struct ieee80211_hw *dev)
 {
 	printk("wbsoft_get_tsf called\n");
@@ -188,7 +180,6 @@ static const struct ieee80211_ops wbsoft_ops = {
 	.add_interface		= wbsoft_add_interface,
 	.remove_interface	= wbsoft_remove_interface,
 	.config			= wbsoft_config,
-	.config_interface	= wbsoft_config_interface,
 	.configure_filter	= wbsoft_configure_filter,
 	.get_stats		= wbsoft_get_stats,
 	.get_tx_stats		= wbsoft_get_tx_stats,

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
