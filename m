Return-Path: <linux-kernel-owner+w=401wt.eu-S1759684AbXEaJHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759684AbXEaJHg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 05:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756020AbXEaJH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 05:07:29 -0400
Received: from mail1.perex.cz ([212.20.107.53]:37795 "EHLO mail1.perex.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756054AbXEaJH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 05:07:28 -0400
Date: Thu, 31 May 2007 11:07:26 +0200 (CEST)
From: Jaroslav Kysela <perex@suse.cz>
X-X-Sender: perex@tm8103.perex-int.cz
To: Linus Torvalds <torvalds@osdl.org>
cc: LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
       Andrew Morton <akpm@osdl.org>
Subject: [ALSA PATCH] alsa-git merge request
Message-ID: <Pine.LNX.4.61.0705311104020.15545@tm8103.perex-int.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull from [the linus branch at]:

  master.kernel.org:/pub/scm/linux/kernel/git/perex/alsa.git linus
gitweb interface:
  http://www.kernel.org/git/?p=linux/kernel/git/perex/alsa.git

The GNU patch is available at:

  ftp://ftp.alsa-project.org/pub/kernel-patches/alsa-git-2007-05-31.patch.gz

Additional notes:

  Only obvious fixes and new HW IDs including quirks mostly for HD Audio.

The following files will be updated:

 Documentation/sound/alsa/ALSA-Configuration.txt |    1 +
 include/sound/version.h                         |    4 +-
 sound/pci/ali5451/ali5451.c                     |    6 +-
 sound/pci/hda/hda_codec.c                       |   13 +++++
 sound/pci/hda/hda_local.h                       |    2 +
 sound/pci/hda/patch_conexant.c                  |   48 +++++++++++++++++-
 sound/pci/hda/patch_realtek.c                   |    5 ++-
 sound/pci/hda/patch_si3054.c                    |    2 +
 sound/pci/hda/patch_sigmatel.c                  |   64 +++++++++++++++++++++--
 sound/soc/s3c24xx/s3c24xx-pcm.c                 |    2 +
 10 files changed, 136 insertions(+), 11 deletions(-)


The following things were done:

Baruch Even (1):
      [ALSA] hda-codec - Add quirk for MSI S420

Christian Rothlaender (1):
      [ALSA] hda-codec - Add support for ASUS A8J modem

Daniel Drake (1):
      [ALSA] hda-intel: fix ASUS M2V detection

Daniel T Chen (1):
      [ALSA] hda-codec - Add quirk for Supermicro PDSBA to alc883_cfg_tbl[]

Jaroslav Kysela (1):
      [ALSA] version 1.0.14

Steve Longerbeam (1):
      [ALSA] hda-codec - Fix pin configs for Gateway MX6453

Takashi Iwai (3):
      [ALSA] ali5451 - Fix possible NULL dereference
      [ALSA] hda-codec - Fix input with STAC92xx
      [ALSA] hda-codec - Fix STAC922x capture boost level

Tobin Davis (4):
      [ALSA] HDA: Add support for Gateway NX860
      [ALSA] HDA: Add more systems to Sigmatel codec
      [ALSA] HDA: Fix headphone mute issue on non-eapd Conexant systems
      [ALSA] hda-codec - Add support for MSI K9N Ultra

Zoltan Devai (1):
      [ALSA] Fix ASoC s3c24xx-pcm spinlock bug

-----
Jaroslav Kysela <perex@suse.cz>
Linux Kernel Sound Maintainer
ALSA Project, SUSE Labs
