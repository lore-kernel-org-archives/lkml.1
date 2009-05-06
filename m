Return-Path: <linux-kernel-owner+w=401wt.eu-S1762505AbZEFWEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762505AbZEFWEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760976AbZEFVyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:54:41 -0400
Received: from kroah.org ([198.145.64.141]:57111 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761406AbZEFVyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:54:38 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:47:58 2009
Message-Id: <20090506214758.482021836@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:45:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [patch 23/58] ASoC: Fix offset of freqmode in WM8580 PLL configuration
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=asoc-fix-offset-of-freqmode-in-wm8580-pll-configuration.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit ce88168f5b5eca7f40394fa6b05ae29f4b685569 upstream.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8580.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/wm8580.c
+++ b/sound/soc/codecs/wm8580.c
@@ -533,7 +533,7 @@ static int wm8580_set_dai_pll(struct snd
 	reg = wm8580_read(codec, WM8580_PLLA4 + offset);
 	reg &= ~0x3f;
 	reg |= pll_div.prescale | pll_div.postscale << 1 |
-		pll_div.freqmode << 4;
+		pll_div.freqmode << 3;
 
 	wm8580_write(codec, WM8580_PLLA4 + offset, reg);
 


