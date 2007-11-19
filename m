Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbXKSSf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbXKSSf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 13:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750978AbXKSSfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 13:35:13 -0500
Received: from mail1.perex.cz ([212.20.107.53]:42886 "EHLO mail1.perex.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbXKSSfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 13:35:11 -0500
Date: Mon, 19 Nov 2007 19:35:09 +0100 (CET)
From: Jaroslav Kysela <perex@perex.cz>
X-X-Sender: perex@tm8103.perex-int.cz
To: Linus Torvalds <torvalds@osdl.org>
cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>
Subject: [ALSA PATCH] alsa-git merge request
Message-ID: <Pine.LNX.4.61.0711191933210.7813@tm8103.perex-int.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull from [the linus branch at]:

  master.kernel.org:/pub/scm/linux/kernel/git/perex/alsa.git linus
gitweb interface:
  http://www.kernel.org/git/?p=linux/kernel/git/perex/alsa.git

The GNU patch is available at:

  ftp://ftp.alsa-project.org/pub/kernel-patches/alsa-git-2007-11-19.patch.gz

Additional notes:

  Just fixes and cleanups.


The following files will be updated:

 include/sound/version.h            |    2 +-
 sound/drivers/mpu401/mpu401_uart.c |   12 +++++++---
 sound/pci/ca0106/ca0106_mixer.c    |   18 ++++++++++-----
 sound/pci/cmipci.c                 |    5 +--
 sound/pci/hda/hda_codec.c          |   40 +++++++++++++++++++++--------------
 sound/pci/hda/hda_local.h          |    1 +
 sound/pci/hda/patch_analog.c       |    8 +++++++
 7 files changed, 56 insertions(+), 30 deletions(-)


The following things were done:

Clemens Ladisch (2):
      [ALSA] cmipci: fix FLINKON/OFF bits
      [ALSA] mpu401: fix recursive locking in timer

Jaroslav Kysela (1):
      [ALSA] version 1.0.15

Takashi Iwai (4):
      [ALSA] hda-codec - Disable shared stream on AD1986A
      [ALSA] hda-codec - Check PINCAP only for PIN widgets
      [ALSA] ca0106 - Check value range in ctl callbacks
      [ALSA] hda-codec - Revert volume knob controls in STAC codecs

-----
Jaroslav Kysela <perex@suse.cz>
Linux Kernel Sound Maintainer
ALSA Project, SUSE Labs
