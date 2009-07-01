Return-Path: <linux-kernel-owner+w=401wt.eu-S1765398AbZGABDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765398AbZGABDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760873AbZGAAfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:35:06 -0400
Received: from kroah.org ([198.145.64.141]:60460 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759390AbZGAAfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:35:02 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:32 2009
Message-Id: <20090701002431.928514647@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [patch 060/108] ASoC: Remove odd bit clock ratios for WM8903
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=asoc-remove-odd-bit-clock-ratios-for-wm8903.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit ba2533a47865ec0dbc72834287a8a048e9337a95 upstream.

These are not supported since performance can not be guaranteed
when they are in use.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8903.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/sound/soc/codecs/wm8903.c
+++ b/sound/soc/codecs/wm8903.c
@@ -1215,22 +1215,18 @@ static struct {
 	int div;
 } bclk_divs[] = {
 	{  10,  0 },
-	{  15,  1 },
 	{  20,  2 },
 	{  30,  3 },
 	{  40,  4 },
 	{  50,  5 },
-	{  55,  6 },
 	{  60,  7 },
 	{  80,  8 },
 	{ 100,  9 },
-	{ 110, 10 },
 	{ 120, 11 },
 	{ 160, 12 },
 	{ 200, 13 },
 	{ 220, 14 },
 	{ 240, 15 },
-	{ 250, 16 },
 	{ 300, 17 },
 	{ 320, 18 },
 	{ 440, 19 },


