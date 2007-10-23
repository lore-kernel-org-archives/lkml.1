Return-Path: <linux-kernel-owner+w=401wt.eu-S1753630AbXJWGOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbXJWGOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 02:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbXJWGOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 02:14:45 -0400
Received: from mail1.perex.cz ([212.20.107.53]:50762 "EHLO mail1.perex.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbXJWGOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 02:14:44 -0400
Date: Tue, 23 Oct 2007 08:14:42 +0200 (CEST)
From: Jaroslav Kysela <perex@perex.cz>
X-X-Sender: perex@tm8103.perex-int.cz
To: Linus Torvalds <torvalds@osdl.org>
cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>
Subject: [ALSA PATCH] alsa-git merge request
Message-ID: <Pine.LNX.4.61.0710230813110.8638@tm8103.perex-int.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull from [the linus branch at]:

  master.kernel.org:/pub/scm/linux/kernel/git/perex/alsa.git linus
gitweb interface:
  http://www.kernel.org/git/?p=linux/kernel/git/perex/alsa.git

The GNU patch is available at:

  ftp://ftp.alsa-project.org/pub/kernel-patches/alsa-git-2007-10-23.patch.gz


The following files will be updated:

 include/sound/version.h        |    2 +-
 sound/core/control.c           |    5 ++-
 sound/pci/bt87x.c              |    4 +-
 sound/pci/hda/hda_codec.c      |    9 +-----
 sound/pci/hda/hda_local.h      |   18 +++++++++---
 sound/pci/hda/patch_analog.c   |    5 ++-
 sound/pci/hda/patch_cmedia.c   |    3 +-
 sound/pci/hda/patch_conexant.c |   35 +++++++++++++----------
 sound/pci/hda/patch_realtek.c  |    2 +-
 sound/pci/hda/patch_sigmatel.c |    6 +++-
 sound/pci/hda/patch_via.c      |    2 +-
 sound/sh/aica.c                |   31 +++++++++++++++++++-
 sound/sparc/cs4231.c           |   59 +++++++++++++---------------------------
 sound/usb/usbquirks.h          |    9 ++++++
 14 files changed, 109 insertions(+), 81 deletions(-)


The following things were done:

Adrian McMenamin (1):
      [ALSA] protect Dreamcast PCM driver (AICA) from G2 bus effects

Borislav Petkov (1):
      [ALSA] sound/core/control.c: hard-irq-safe -> hard-irq-unsafe lock warning

Dawid Wrobel (1):
      [ALSA] usb-audio: Another USB mic quirk for Logitech Communicator webcam

Jaroslav Kysela (1):
      [ALSA] version 1.0.15

Krzysztof Helt (1):
      [ALSA] This simplifies and fixes waiting loops of the mce_down()

Takashi Iwai (6):
      [ALSA] hda-codec - Fix AD1986A Lenovo auto-mute
      [ALSA] bt87x - Fix section mismatch
      [ALSA] hda-codec - Fix conflict of Master volume in STAC92xx codec
      [ALSA] hda-codec - Fix Conexant 5045 volumes
      [ALSA] hda-codec - Fix build without CONFIG_SND_HDA_GENERIC
      [ALSA] hda-codec - Fix possible array overflow

Trent Piepho (1):
      [ALSA] snd-bt87x: Make the load_all option work correctly

-----
Jaroslav Kysela <perex@suse.cz>
Linux Kernel Sound Maintainer
ALSA Project, SUSE Labs
