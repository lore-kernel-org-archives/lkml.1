Return-Path: <linux-kernel-owner+w=401wt.eu-S1757650AbZADQg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650AbZADQg2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 11:36:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbZADQfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 11:35:45 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:59046 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757972AbZADQfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 11:35:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=ayBSWs2ea/TLWb6YebeQIXTs2NMUswl2oU25secKX/p+Y/G455p/O/OdAokUdrmKLQ
         1sfyYjvVqdeLE3MtCuZmGtfBShHNdMLVnmp5kqp/5kJ5/p86gyoHKvurTuVFAPkd+R9l
         MciX5XJd2GdTKdLESUj5yFIAmmy7ocE2x28dE=
Message-ID: <4960E55F.3040904@gmail.com>
Date: Sun, 04 Jan 2009 17:35:43 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: solomon@linux-wlan.com, Greg KH <gregkh@suse.de>
CC: linux-wireless@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] Staging: ! has a higher precedence than &
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

! has a higher precedence than &

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
I know checkpatch complains, but all whitespace in this file is like this

diff --git a/drivers/staging/wlan-ng/p80211wext.c b/drivers/staging/wlan-ng/p80211wext.c
index 906ba43..c42cd7f 100644
--- a/drivers/staging/wlan-ng/p80211wext.c
+++ b/drivers/staging/wlan-ng/p80211wext.c
@@ -1580,7 +1580,7 @@ static int p80211wext_set_encodeext(struct net_device *dev,
 
 
   if ( ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY ) {
-    if ( ! ext->alg & IW_ENCODE_ALG_WEP) {
+    if (!(ext->alg & IW_ENCODE_ALG_WEP)) {
       WLAN_LOG_DEBUG(1,"asked to set a non wep key :(");
       return -EINVAL;
     }

