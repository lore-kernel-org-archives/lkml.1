Return-Path: <linux-kernel-owner+w=401wt.eu-S965054AbXCFOU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965054AbXCFOU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 09:20:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965055AbXCFOU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 09:20:58 -0500
Received: from gate.perex.cz ([212.20.107.50]:45377 "EHLO gate.perex.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965054AbXCFOU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 09:20:58 -0500
Date: Tue, 6 Mar 2007 15:20:53 +0100 (CET)
From: Jaroslav Kysela <perex@suse.cz>
X-X-Sender: perex@tm8103.perex-int.cz
To: Linus Torvalds <torvalds@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Takashi Iwai <tiwai@suse.de>
Subject: [ALSA PATCH] alsa-git merge request
Message-ID: <Pine.LNX.4.61.0703061412300.8516@tm8103.perex-int.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull from [the linus branch at]:

  master.kernel.org:/pub/scm/linux/kernel/git/perex/alsa.git linus
gitweb interface:
  http://www.kernel.org/git/?p=linux/kernel/git/perex/alsa.git

The GNU patch is available at:

  ftp://ftp.alsa-project.org/pub/kernel-patches/alsa-git-2007-03-06.patch.gz

The following files will be updated:

 Documentation/sound/alsa/ALSA-Configuration.txt |   12 ++++++-
 include/sound/version.h                         |    4 +-
 sound/pci/ac97/ac97_patch.c                     |    2 +
 sound/pci/ali5451/ali5451.c                     |    2 +
 sound/pci/cmipci.c                              |   18 +++++++----
 sound/pci/echoaudio/echoaudio.c                 |    2 +
 sound/pci/hda/patch_analog.c                    |    3 ++
 sound/pci/hda/patch_conexant.c                  |    8 ++++-
 sound/pci/hda/patch_realtek.c                   |   21 ++++++++++++--
 sound/pci/hda/patch_sigmatel.c                  |   35 +++++++++++++++++++++--
 sound/pci/riptide/riptide.c                     |    2 +
 sound/pci/rme9652/hdspm.c                       |    2 +
 sound/soc/codecs/wm9712.c                       |    3 +-
 13 files changed, 94 insertions(+), 20 deletions(-)


The following things were done:

Jaroslav Kysela (1):
      [ALSA] version 1.0.14rc3

Joe Sauer (1):
      [ALSA] soc - Fix WM9712 register cache entry

Liam Girdwood (1):
      [ALSA] soc - WM9712 PCM volume

Takashi Iwai (7):
      [ALSA] hda-codec - Add LFE support on Dell M90
      [ALSA] hda-codec - Add missing Mic Boost controls for ALC262
      [ALSA] hda-codec - Define pin configs for MacBooks
      [ALSA] Add missing sysfs device assignment for ALSA PCI drivers
      [ALSA] ac97 - Add Thinkpad X31 and R40 to AD1981x blacklist
      [ALSA] hda-codec - Add missing Mic Boost for AD1986A codec
      [ALSA] cmipci - Allow to disable integrated FM port

Tobin Davis (2):
      [ALSA] hda-codec - Add method for configuring Mac Pro without PCI SSID
      [ALSA] hda-codec - Fix logic error in headphone mute for Conexant codecs


-----
Jaroslav Kysela <perex@suse.cz>
Linux Kernel Sound Maintainer
ALSA Project, SUSE Labs
