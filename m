Return-Path: <linux-kernel-owner+w=401wt.eu-S1759997AbXEPJuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997AbXEPJuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 05:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756030AbXEPJuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 05:50:46 -0400
Received: from mail1.perex.cz ([212.20.107.53]:51402 "EHLO mail1.perex.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641AbXEPJup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 05:50:45 -0400
Date: Wed, 16 May 2007 11:50:43 +0200 (CEST)
From: Jaroslav Kysela <perex@suse.cz>
X-X-Sender: perex@tm8103-a.perex-int.cz
To: Linus Torvalds <torvalds@osdl.org>
cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Takashi Iwai <tiwai@suse.de>
Subject: [ALSA PATCH] alsa-git merge request
Message-ID: <Pine.LNX.4.61.0705161149050.8048@tm8103-a.perex-int.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull from [the linus branch at]:

  master.kernel.org:/pub/scm/linux/kernel/git/perex/alsa.git linus
gitweb interface:
  http://www.kernel.org/git/?p=linux/kernel/git/perex/alsa.git

The GNU patch is available at:

  ftp://ftp.alsa-project.org/pub/kernel-patches/alsa-git-2007-05-16.patch.gz


The following files will be updated:

 include/sound/soc.h           |    4 +-
 include/sound/version.h       |    2 +-
 sound/pci/hda/hda_codec.c     |    3 +-
 sound/pci/hda/patch_realtek.c |  532 +++++++++++++++++++++++++++++++++++++++--
 sound/soc/codecs/ac97.c       |    3 +-
 sound/soc/codecs/wm9712.c     |    1 +
 sound/soc/soc-core.c          |   18 ++-
 sound/usb/usbquirks.h         |    9 +
 8 files changed, 548 insertions(+), 24 deletions(-)


The following things were done:

Daniel Drake (1):
      [ALSA] usb-audio: another Logitech QuickCam ID

Jaroslav Kysela (1):
      [ALSA] version 1.0.14rc4

Kailang Yang (1):
      [ALSA] hda-codec - Fix ALC882/861VD codec support on some laptops

Liam Girdwood (2):
      [ALSA] ASoC AC97 static GPL symbol fix
      [ALSA] ASoC AC97 device reg bugfix

Takashi Iwai (1):
      [ALSA] hda-codec - Make the mixer capability check more robust

-----
Jaroslav Kysela <perex@suse.cz>
Linux Kernel Sound Maintainer
ALSA Project, SUSE Labs
