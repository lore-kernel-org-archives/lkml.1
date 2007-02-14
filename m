Return-Path: <linux-kernel-owner+w=401wt.eu-S932175AbXBNHqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175AbXBNHqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 02:46:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932177AbXBNHqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 02:46:48 -0500
Received: from gate.perex.cz ([212.20.107.50]:41143 "EHLO gate.perex.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932175AbXBNHqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 02:46:47 -0500
Date: Wed, 14 Feb 2007 08:46:45 +0100 (CET)
From: Jaroslav Kysela <perex@suse.cz>
X-X-Sender: perex@tm8103.perex-int.cz
To: Linus Torvalds <torvalds@osdl.org>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>
Subject: [ALSA PATCH] alsa-git merge request
Message-ID: <Pine.LNX.4.61.0702140844300.7697@tm8103.perex-int.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please do an update from:

  http://www.kernel.org/pub/scm/linux/kernel/git/perex/alsa.git
  (linus branch)

The GNU patch is available at:

  ftp://ftp.alsa-project.org/pub/kernel-patches/alsa-git-2007-02-14.patch.gz

Additional notes:

  Mostly fixes and cleanups.


The following files will be updated:

 include/sound/emu10k1.h        |    2 +-
 include/sound/version.h        |    2 +-
 sound/arm/pxa2xx-ac97.c        |    6 +-
 sound/drivers/dummy.c          |   11 +-
 sound/drivers/mtpav.c          |   12 +-
 sound/drivers/mts64.c          |    6 +-
 sound/drivers/portman2x4.c     |    6 +-
 sound/drivers/serial-u16550.c  |   14 +-
 sound/drivers/virmidi.c        |    6 +-
 sound/isa/ad1848/ad1848.c      |    2 +-
 sound/isa/cmi8330.c            |    4 +-
 sound/isa/es1688/es1688.c      |    6 +-
 sound/isa/gus/gusclassic.c     |   10 +-
 sound/isa/gus/gusextreme.c     |   12 +-
 sound/isa/gus/gusmax.c         |   13 +-
 sound/isa/opl3sa2.c            |    4 +-
 sound/isa/sb/sb8.c             |    6 +-
 sound/pci/ac97/ac97_codec.c    |    1 +
 sound/pci/ac97/ac97_patch.c    |    6 +
 sound/pci/ac97/ac97_patch.h    |    1 +
 sound/pci/hda/patch_conexant.c |  343 ++++++++++++++++++++++++++--------------
 sound/pci/hda/patch_sigmatel.c |   44 +++++
 sound/soc/at91/at91-i2s.c      |   43 +++---
 sound/soc/at91/at91-pcm.c      |   20 ++--
 sound/soc/codecs/Kconfig       |    8 +-
 sound/usb/usbaudio.c           |   10 --
 sound/usb/usbquirks.h          |   23 +++
 27 files changed, 394 insertions(+), 227 deletions(-)


The following things were done:

Clemens Ladisch (2):
      [ALSA] emu10k1: fix typo
      [ALSA] usb-audio: add PCR-A PCM support

Frank Mandarino (1):
      [ALSA] Change AT91 PDC register defines for 2.6.20 kernel

Jaroslav Kysela (2):
      [ALSA] SoC codecs - fix Kconfig - depends -> depends on
      [ALSA] version 1.0.14rc2

Jiri Kosina (1):
      [ALSA] usbaudio - remove urb->bandwidth reference

Mikael Nilsson (1):
      [ALSA] hda-codec - Patch for enabling LFE on more Dell laptops

Prarit Bhargava (1):
      [ALSA] Fix __devinit and __devexit issues with sound drivers

Takashi Iwai (3):
      [ALSA] hda-codec - Fix Oops with probing sigmatel codec chips
      [ALSA] ac97 - Fix silent output problem with Cx20551 codec
      [ALSA] Fix a typo in __dev* changes in portman2x4.c

Tobin Davis (1):
      [ALSA] hda-codec - More fixes for Conexant HD Audio support

-----
Jaroslav Kysela <perex@suse.cz>
Linux Kernel Sound Maintainer
ALSA Project, SUSE Labs
