Return-Path: <linux-kernel-owner+w=401wt.eu-S1753643Ab0ADWfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab0ADWfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 17:35:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280Ab0ADWfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 17:35:22 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48173 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753020Ab0ADWfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 17:35:22 -0500
Date: Mon, 4 Jan 2010 22:35:17 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Takashi Iwai <tiwai@suse.de>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: ASoC updates for 2.6.33
Message-ID: <20100104223517.GA3865@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit c5974b835a909ff15c3b7e6cf6789b5eb919f419:
  Linus Torvalds (1):
        Merge branch 'limits_cleanup' of git://decibel.fi.muni.cz/~xslaby/linux

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound-2.6.git for-2.6.33

Takashi is on holiday for the first few weeks of the year so he said to
send direct pull requests in the interim.  The patch from Morimoto-san
is finishing off a cross-tree merge while the others are driver-specific
fixes.

Guennadi Liakhovetski (1):
      ASoC: fix params_rate() macro use in several codecs

Kuninori Morimoto (1):
      ASoC: fsi-ak4642: Remove ak4642_add_i2c_device

Manuel Lauss (1):
      ASoC: fixup oops in generic AC97 codec glue

Mark Brown (1):
      Merge commit 'v2.6.33-rc2' into for-2.6.33

 sound/soc/codecs/ac97.c   |    6 ++++++
 sound/soc/codecs/wm8510.c |   14 +++++++-------
 sound/soc/codecs/wm8940.c |   14 +++++++-------
 sound/soc/codecs/wm8974.c |   14 +++++++-------
 sound/soc/sh/fsi-ak4642.c |   30 ------------------------------
 5 files changed, 27 insertions(+), 51 deletions(-)
