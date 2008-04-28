Return-Path: <linux-kernel-owner+w=401wt.eu-S965033AbYD1Po3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965033AbYD1Po3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964958AbYD1Pjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:39:43 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:49123 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964954AbYD1Pjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:39:42 -0400
Date: Mon, 28 Apr 2008 18:39:09 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Patrick Boettcher <pb@linuxtv.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make itd1000_fre_values[] static const
Message-ID: <20080428153909.GL2813@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

itd1000_fre_values[] can become static const.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
60d7bc869ba7395f6037b609a62638e1332aec48 diff --git a/drivers/media/dvb/frontends/itd1000.c b/drivers/media/dvb/frontends/itd1000.c
index 04c562c..600dad6 100644
--- a/drivers/media/dvb/frontends/itd1000.c
+++ b/drivers/media/dvb/frontends/itd1000.c
@@ -195,7 +195,7 @@ static void itd1000_set_vco(struct itd1000_state *state, u32 freq_khz)
 	}
 }
 
-struct {
+static const struct {
 	u32 freq;
 	u8 values[10]; /* RFTR, RFST1 - RFST9 */
 } itd1000_fre_values[] = {

