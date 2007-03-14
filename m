Return-Path: <linux-kernel-owner+w=401wt.eu-S1030694AbXCNH2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030694AbXCNH2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 03:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030693AbXCNH2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 03:28:22 -0400
Received: from mail1.perex.cz ([212.20.107.53]:56193 "EHLO mail1.perex.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030694AbXCNH2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 03:28:21 -0400
Date: Wed, 14 Mar 2007 08:28:19 +0100 (CET)
From: Jaroslav Kysela <perex@suse.cz>
X-X-Sender: perex@tm8103.perex-int.cz
To: Linus Torvalds <torvalds@osdl.org>
cc: Andrew Morton <akpm@osdl.org>, Takashi Iwai <tiwai@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [ALSA PATCH] alsa-git merge request
Message-ID: <Pine.LNX.4.61.0703140826380.8322@tm8103.perex-int.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull from [the linus branch at]:

  master.kernel.org:/pub/scm/linux/kernel/git/perex/alsa.git linus
gitweb interface:
  http://www.kernel.org/git/?p=linux/kernel/git/perex/alsa.git

The GNU patch is available at:

  ftp://ftp.alsa-project.org/pub/kernel-patches/alsa-git-2007-03-14.patch.gz

Additional notes:

  Only fixes / new hardware IDs.


The following files will be updated:

 Documentation/sound/alsa/ALSA-Configuration.txt |    1 +
 include/sound/version.h                         |    2 +-
 sound/pci/ac97/ac97_patch.c                     |   13 ++++---
 sound/pci/hda/hda_intel.c                       |   13 ++++++-
 sound/pci/hda/patch_analog.c                    |   41 +++++++++++++++++++++--
 sound/pci/hda/patch_realtek.c                   |    1 +
 sound/pci/hda/patch_sigmatel.c                  |    5 +++
 sound/pci/intel8x0.c                            |   10 ++++--
 sound/soc/Kconfig                               |    2 +
 sound/soc/at91/Kconfig                          |    3 +-
 sound/soc/pxa/Kconfig                           |    3 +-
 11 files changed, 76 insertions(+), 18 deletions(-)


The following things were done:

Jaroslav Kysela (1):
      [ALSA] version 1.0.14rc3

Randy Cushman (1):
      [ALSA] ac97 - fix AD shared shared jack control logic

Takashi Iwai (5):
      [ALSA] soc - Fix dependencies in Kconfig files
      [ALSA] hda-intel - Fix codec probe with ATI contorllers
      [ALSA] hda-codec - Fix speaker output on MacPro
      [ALSA] intel8x0 - Fix Oops at kdump crash kernel
      [ALSA] hda-codec - Add model for HP Compaq d5700

Tobin Davis (2):
      [ALSA] hda-codec - Add suppoprt for Asus M2N-SLI motherboard
      [ALSA] hda-codec - more systems for Analog Devices

Tommi Kyntola (1):
      [ALSA] intel8x0 - Fix speaker output after S2RAM
