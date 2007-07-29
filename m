Return-Path: <linux-kernel-owner+w=401wt.eu-S1764927AbXG2PAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764927AbXG2PAn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763920AbXG2O5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:57:30 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47775 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763737AbXG2O52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:57:28 -0400
Date: Sun, 29 Jul 2007 16:57:05 +0200
From: Adrian Bunk <bunk@stusta.de>
To: v4l-dvb-maintainer@linuxtv.org
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make struct dvb_pll_fcv1236d static
Message-ID: <20070729145705.GK16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

struct dvb_pll_fcv1236d can become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.23-rc1-mm1/drivers/media/dvb/frontends/dvb-pll.c.old	2007-07-26 09:04:23.000000000 +0200
+++ linux-2.6.23-rc1-mm1/drivers/media/dvb/frontends/dvb-pll.c	2007-07-26 09:04:32.000000000 +0200
@@ -501,7 +501,7 @@
 
 /* Philips FCV1236D
  */
-struct dvb_pll_desc dvb_pll_fcv1236d = {
+static struct dvb_pll_desc dvb_pll_fcv1236d = {
 /* Bit_0: RF Input select
  * Bit_1: 0=digital, 1=analog
  */

