Return-Path: <linux-kernel-owner+w=401wt.eu-S1752617AbXA2Wvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbXA2Wvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 17:51:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932827AbXA2Wvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 17:51:54 -0500
Received: from ns1.suse.de ([195.135.220.2]:45220 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617AbXA2Wvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 17:51:53 -0500
Date: Mon, 29 Jan 2007 14:50:55 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, perex@suse.cz,
       alsa-devel@alsa-project.org
Subject: [GIT PATCH] ALSA core fix for 2.6.20-rc5
Message-ID: <20070129225055.GA4796@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi asked me to send you this single patch as it conflicted with his
current tree and it is needed before 2.6.20 comes out to fix a userspace
ABI breakage that I caused earlier.

This patch fixes a bug with the sound core when CONFIG_SYSFS_DEPRECATED
is enabled.  More details can be found in the patch itself, which will
follow as a reply to this message.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/

thanks,

greg k-h


 include/sound/core.h   |   18 +++++++++++++++---
 sound/core/init.c      |   18 +++++++++++-------
 sound/core/sound.c     |    4 +---
 sound/core/sound_oss.c |    4 +---
 4 files changed, 28 insertions(+), 16 deletions(-)

---------------

Takashi Iwai (1):
      ALSA: Fix sysfs breakage

