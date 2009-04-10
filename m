Return-Path: <linux-kernel-owner+w=401wt.eu-S1759960AbZDJBmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759960AbZDJBmB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 21:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759614AbZDJBls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 21:41:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51597 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758835AbZDJBlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 21:41:47 -0400
Message-ID: <49DEA405.3070900@cn.fujitsu.com>
Date: Fri, 10 Apr 2009 09:42:29 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: tiwai@suse.de
CC: perex@perex.cz, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] sound: use memdup_user()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove open-coded memdup_user() in sound/

   text    data     bss     dec     hex filename
5206937  929788 5320496 11457221         aed2c5 vmlinux.o.orig
   text    data     bss     dec     hex filename
5205277  929788 5320496 11455561         aecc49 vmlinux.o

 sound/core/control.c                  |   35 +++++--------
 sound/core/pcm_compat.c               |   11 ++---
 sound/core/pcm_native.c               |   93 ++++++++++++--------------------
 sound/core/seq/seq_compat.c           |    9 ++--
 sound/core/timer.c                    |   11 ++---
 sound/isa/sb/sb16_csp.c               |   19 ++++---
 sound/isa/wavefront/wavefront_fx.c    |   14 ++---
 sound/isa/wavefront/wavefront_synth.c |   11 ++--
 sound/pci/emu10k1/emufx.c             |   41 +++++----------
 sound/usb/usx2y/us122l.c              |   10 +---
 sound/usb/usx2y/usX2Yhwdep.c          |   13 ++---
 11 files changed, 102 insertions(+), 165 deletions(-)
---
