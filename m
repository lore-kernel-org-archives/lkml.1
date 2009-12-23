Return-Path: <linux-kernel-owner+w=401wt.eu-S1752391AbZLWBeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbZLWBeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 20:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbZLWBeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 20:34:23 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:3176 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbZLWBeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 20:34:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=YKSz3I/Z/J+l4AtnaEWIdBzGujPexzts6TR75OfPCR6j9IkkB6iuNZrJGT3MU3o7r3
         4jbeBFdQlxMeBfo1GlkDwta1pVs1C7IJcetkyEs/DB7jRIgeZbxreJtyhMxUW0EmkI+N
         NJ8yTNoh6rqdaktAQqp21DaqAQXgEf5BZkr3k=
Message-ID: <4B31742B.9040809@gmail.com>
Date: Wed, 23 Dec 2009 02:36:43 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ieee80211: add missing parentheses
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

not(!) has a higher precedence than bit and(&).

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

I think this one was not yet reported.

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
index d397f1d..0aaa30f 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
@@ -718,7 +718,7 @@ int ieee80211_wx_get_encode_ext(struct ieee80211_device *ieee,
 	} else
 		idx = ieee->tx_keyidx;
 
-	if (!ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY &&
+	if (!(ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY) &&
 	    ext->alg != IW_ENCODE_ALG_WEP)
 		if (idx != 0 || ieee->iw_mode != IW_MODE_INFRA)
 			return -EINVAL;
