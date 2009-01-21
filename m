Return-Path: <linux-kernel-owner+w=401wt.eu-S1759814AbZAUSKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759814AbZAUSKt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 13:10:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759745AbZAUSJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 13:09:18 -0500
Received: from kroah.org ([198.145.64.141]:58565 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759750AbZAUSJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 13:09:16 -0500
Subject: patch staging-otus-logical-bit-and-confusion.patch added to gregkh-2.6 tree
To: roel.kluin@gmail.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       lrodriguez@atheros.com
From: <gregkh@suse.de>
Date: Wed, 21 Jan 2009 10:07:05 -0800
In-Reply-To: <4971E0F9.508@gmail.com>
Message-ID: <12325612253994@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: Staging: otus: logical/bit and confusion

to my gregkh-2.6 tree.  Its filename is

    staging-otus-logical-bit-and-confusion.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From roel.kluin@gmail.com  Wed Jan 21 09:43:08 2009
From: Roel Kluin <roel.kluin@gmail.com>
Date: Sat, 17 Jan 2009 14:45:29 +0100
Subject: Staging: otus: logical/bit and confusion
To: lrodriguez@atheros.com, Greg KH <gregkh@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>
Message-ID: <4971E0F9.508@gmail.com>


fix logical/bit and confusion

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: <lrodriguez@atheros.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/otus/80211core/cwm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/staging/otus/80211core/cwm.c
+++ b/drivers/staging/otus/80211core/cwm.c
@@ -75,9 +75,9 @@ void zfCoreCwmBusy(zdev_t* dev, u16_t bu
 
     if((wd->wlanMode == ZM_MODE_INFRASTRUCTURE || wd->wlanMode == ZM_MODE_PSEUDO ||
         wd->wlanMode == ZM_MODE_IBSS)) {
-        if (wd->sta.ie.HtCap.HtCapInfo && HTCAP_SupChannelWidthSet != 0 &&
-            wd->sta.ie.HtInfo.ChannelInfo && ExtHtCap_RecomTxWidthSet != 0 &&
-            (wd->sta.ie.HtInfo.ChannelInfo && ExtHtCap_ExtChannelOffsetAbove) == 1) {
+        if ((wd->sta.ie.HtCap.HtCapInfo & HTCAP_SupChannelWidthSet) &&
+            (wd->sta.ie.HtInfo.ChannelInfo & ExtHtCap_RecomTxWidthSet) &&
+            (wd->sta.ie.HtInfo.ChannelInfo & ExtHtCap_ExtChannelOffsetAbove)) {
 
             wd->cwm.cw_width = CWM_WIDTH40;
         }


Patches currently in gregkh-2.6 which might be from roel.kluin@gmail.com are

staging/staging-meilhaus-unsigned-won-t-get-negative-after-subtraction.patch
staging/staging-otus-logical-bit-and-confusion.patch
