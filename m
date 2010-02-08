Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab0BHQjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 11:39:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529Ab0BHQjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 11:39:05 -0500
Message-ID: <4B703E1D.8090705@redhat.com>
Date: Mon, 08 Feb 2010 14:38:53 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Media Mailing List <linux-media@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 3.2.33] Fix regressions on dvb demux
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6339204ecc2aa2067a99595522de0403f0854bb8:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../viro/vfs-2.6

are available in the git repository at:

  ssh://linuxtv.org/git/fixes.git v4l_for_linus

Those patches addresses the regression on 2.3.32 on dvb core.

Francesco Lavra (1):
      V4L/DVB: dvb-core: fix initialization of feeds list in demux filter

Mauro Carvalho Chehab (2):
      V4L/DVB: Fix the risk of an oops at dvb_dmx_release
      V4L/DVB: dvb_demux: Don't use vmalloc at dvb_dmx_swfilter_packet

 drivers/media/dvb/dvb-core/dmxdev.c    |    2 +-
 drivers/media/dvb/dvb-core/dvb_demux.c |   20 +++++++++-----------
 2 files changed, 10 insertions(+), 12 deletions(-)

-- 

Cheers,
Mauro
