Return-Path: <linux-kernel-owner+w=401wt.eu-S1754562AbYDGTI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbYDGTI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 15:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbYDGTIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 15:08:19 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:58441 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbYDGTIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 15:08:18 -0400
Date: Mon, 7 Apr 2008 21:08:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@osdl.org>, kernel list <linux-kernel@vger.kernel.org>,
       j@w1.fi, flamingice@sourmilk.net, dyoung@pobox.com,
       Trivial patch monkey <trivial@kernel.org>
Subject: adm8211: remove commented-out code
Message-ID: <20080407190855.GA18799@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some commented-out code from adm8211.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index 7979618..b52b1b0 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -465,9 +465,6 @@ do {									   \
 	if (stsr & ADM8211_STSR_TCI)
 		adm8211_interrupt_tci(dev);
 
-	/*ADM8211_INT(LinkOn);*/
-	/*ADM8211_INT(LinkOff);*/
-
 	ADM8211_INT(PCF);
 	ADM8211_INT(BCNTC);
 	ADM8211_INT(GPINT);
@@ -477,7 +474,6 @@ do {									   \
 	ADM8211_INT(SQL);
 	ADM8211_INT(WEPTD);
 	ADM8211_INT(ATIME);
-	/*ADM8211_INT(TBTT);*/
 	ADM8211_INT(TEIS);
 	ADM8211_INT(FBE);
 	ADM8211_INT(REIS);
@@ -485,9 +481,6 @@ do {									   \
 	ADM8211_INT(RPS);
 	ADM8211_INT(RDU);
 	ADM8211_INT(TUF);
-	/*ADM8211_INT(TRT);*/
-	/*ADM8211_INT(TLT);*/
-	/*ADM8211_INT(TDU);*/
 	ADM8211_INT(TPS);
 
 	return IRQ_HANDLED;

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
