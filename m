Return-Path: <linux-kernel-owner+w=401wt.eu-S1760637AbZCPOmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760637AbZCPOmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 10:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbZCPOmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 10:42:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44800 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751982AbZCPOmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 10:42:00 -0400
Date: Mon, 16 Mar 2009 14:41:57 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: ASoC updates for 2.6.30
Message-ID: <20090316144157.GA6338@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: Ontogeny recapitulates phylogeny.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 77dd7e17b86bd81b3638e01d784a72652071508b:
  Lopez Cruz, Misael (1):
        ASoC: Move headset jack registration to device initialization for SDP3430

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound-2.6.git for-2.6.30

Joonyoung Shim (1):
      ASoC: twl4030 - Fix build error

Mark Brown (2):
      ASoC: Fix some missing dai_ops conversions
      ASoC: Each PXA AC97 DAI needs a separate ops

Robert Jarzmik (1):
      ASoC: Allow choice of ac97 gpio reset line

 include/sound/pxa2xx-lib.h      |   15 ++++++++
 sound/arm/pxa2xx-ac97-lib.c     |   71 ++++++++++++++++++++++++++++++++++++---
 sound/soc/codecs/twl4030.c      |   12 ++++---
 sound/soc/pxa/pxa2xx-ac97.c     |   16 ++++++--
 sound/soc/s3c24xx/s3c64xx-i2s.c |    8 +++--
 sound/soc/sh/hac.c              |   12 +++---
 6 files changed, 111 insertions(+), 23 deletions(-)
