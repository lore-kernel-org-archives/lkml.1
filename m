Return-Path: <linux-kernel-owner+w=401wt.eu-S933290AbXBXAhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933290AbXBXAhg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 19:37:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933293AbXBXAhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 19:37:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:39063 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933290AbXBXAha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 19:37:30 -0500
Date: Fri, 23 Feb 2007 16:36:02 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@osdl.org>, torvalds@osdl.org, stable@kernel.org
Subject: Linux 2.6.19.5
Message-ID: <20070224003602.GA14141@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.19.5 kernel.
It contains a number of bugfixes, and all 2.6.19 users are recommended
to upgrade.

There will be one more 2.6.19 based release, due to all of the patches
that people have sent in after the review set of patches for this
release was posted.  So if you have sent in new patches, don't worry if
you do not see them in this release, they should be taken care of next
week.

The diffstat and short summary of the fixes are below.

I'll also be replying to this message with a copy of the patch between
2.6.19.4 and 2.6.19.5, as it is small enough to do so.

The updated 2.6.19.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.19.y.git
and can be browsed at the normal kernel.org git web browser:
        www.kernel.org/git/

thanks,

greg k-h
--------

 Makefile                                          |    2 
 arch/x86_64/ia32/ptrace32.c                       |    1 
 drivers/ata/pata_amd.c                            |    4 -
 drivers/ide/ide-iops.c                            |    2 
 drivers/media/video/ks0127.c                      |    8 +-
 drivers/media/video/tveeprom.c                    |    2 
 drivers/media/video/usbvideo/quickcam_messenger.h |   14 -----
 drivers/media/video/video-buf.c                   |    1 
 drivers/net/8139too.c                             |    5 +
 drivers/net/smc911x.c                             |    5 +
 drivers/net/wireless/bcm43xx/bcm43xx.h            |    2 
 drivers/net/wireless/bcm43xx/bcm43xx_main.c       |    8 +-
 drivers/net/wireless/bcm43xx/bcm43xx_xmit.h       |   10 ---
 drivers/net/wireless/prism54/isl_ioctl.c          |    8 ++
 drivers/rtc/rtc-pcf8563.c                         |   40 ++++++++++++--
 fs/aio.c                                          |   20 +++----
 include/asm-x86_64/bitops.h                       |   34 +++++++-----
 include/linux/sunrpc/svcsock.h                    |    2 
 net/sunrpc/svc.c                                  |    4 -
 net/sunrpc/svcsock.c                              |   52 ++++++++++++++-----
 security/keys/key.c                               |   33 +++++-------
 sound/usb/usbaudio.c                              |   59 ++++++++++++++--------
 22 files changed, 188 insertions(+), 128 deletions(-)


Summary of changes from v2.6.18.7 to v2.6.18.8
==============================================

Andi Kleen (1):
      Use different constraint for gcc < 4.1 in bitops.

Atsushi Nemoto (1):
      rtc-pcf8563: detect polarity of century bit automatically

Dan Williams (1):
      prism54: correct assignment of DOT1XENABLE in WE-19 codepaths

David Howells (1):
      Keys: Fix key serial number collision handling

Grant Likely (1):
      V4L: Fix quickcam communicator driver for big endian architectures

Greg Kroah-Hartman (1):
      Linux 2.6.19.5

Ingo Molnar (1):
      net, 8139too.c: fix netpoll deadlock

Ken Chen (1):
      aio: fix buggy put_ioctx call in aio_complete - v2

Larry Finger (1):
      bcm43xx: Fix for oops on resume

Martin Samuelsson (1):
      V4L: fix ks0127 status flags

Michael Buesch (1):
      bcm43xx: Fix for oops on ampdu status

Michael Krufky (1):
      V4L: tveeprom: autodetect LG TAPC G701D as tuner type 37

NeilBrown (1):
      knfsd: Fix a race in closing NFSd connections.

Oleg Nesterov (1):
      V4L: buf_qbuf: fix videobuf_queue->stream corruption and lockup

Paolo 'Blaisorblade' Giarrusso (1):
      x86_64: fix 2.6.18 regression - PTRACE_OLDSETOPTIONS should be accepted

Peter Korsgaard (1):
      net/smc911x: match up spin lock/unlock

Takashi Iwai (3):
      usb-audio: work around wrong frequency in CM6501 descriptors
      usbaudio - Fix Oops with broken usb descriptors
      usbaudio - Fix Oops with unconventional sample rates

Tejun Heo (2):
      ide: fix drive side 80c cable check
      pata_amd: fix an obvious bug in cable detection

