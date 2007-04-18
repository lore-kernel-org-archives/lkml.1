Return-Path: <linux-kernel-owner+w=401wt.eu-S2992855AbXDRWW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992855AbXDRWW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 18:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992864AbXDRWW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 18:22:58 -0400
Received: from smtp2-g19.free.fr ([212.27.42.28]:38071 "EHLO smtp2-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992855AbXDRWW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 18:22:57 -0400
Message-ID: <462699F9.3040503@tremplin-utc.net>
Date: Thu, 19 Apr 2007 00:21:45 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>
User-Agent: Thunderbird 2.0b2 (X11/20070307)
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@insightbb.com>
CC: mitr@volny.cz, otauber@web.de, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] wistron_btns: add led support
Content-Type: multipart/mixed;
 boundary="------------010800020106060507070805"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010800020106060507070805
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

This fix a typo on the TM610 definition, inserted in my recent patch 
"add-acerhk-database".

Eric


--------------010800020106060507070805
Content-Type: text/x-patch;
 name="wistron_btns-add-acerhk-database-2.6.21-fix-tm610.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="wistron_btns-add-acerhk-database-2.6.21-fix-tm610.patch"

From: Eric Piel <eric.piel@tremplin-utc.net>

wriston_btns: Fix typo for TM610
I did a typo in a previous patch for wistron_btns "add acerhk database". This
patch fixes this typo that prevented PROG2 key to work.

Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>

--- linux-2.6.21/drivers/input/misc/wistron_btns.c.bak	2007-04-07 15:09:30.000000000 +0200
+++ linux-2.6.21/drivers/input/misc/wistron_btns.c	2007-04-07 15:09:44.000000000 +0200
@@ -490,7 +490,7 @@
 	{ KE_KEY, 0x01, {KEY_HELP} },
 	{ KE_KEY, 0x02, {KEY_CONFIG} },
 	{ KE_KEY, 0x11, {KEY_PROG1} },
-	{ KE_KEY, 0x12, {KEY_PROG3} },
+	{ KE_KEY, 0x12, {KEY_PROG2} },
 	{ KE_KEY, 0x13, {KEY_PROG3} },
 	{ KE_KEY, 0x14, {KEY_MAIL} },
 	{ KE_KEY, 0x15, {KEY_WWW} },

--------------010800020106060507070805--
