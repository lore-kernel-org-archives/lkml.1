Return-Path: <linux-kernel-owner+w=401wt.eu-S1759145AbYJVWUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759145AbYJVWUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 18:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759632AbYJVWTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 18:19:15 -0400
Received: from kroah.org ([198.145.64.141]:54895 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759409AbYJVWTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 18:19:10 -0400
Date: Wed, 22 Oct 2008 15:15:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.25.19
Message-ID: <20081022221519.GE15277@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.25.19
kernel.

It contains a wide range of bugfixes, and all users of the 2.6.25 kernel
series are strongly encouraged to upgrade.

There is probably only going to be one more 2.6.25 kernel release so
everyone should be migrating to 2.6.27 at this point in time.

I'll also be replying to this message with a copy of the patch between
2.6.25.18 and 2.6.25.19

The updated 2.6.25.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.25.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.25.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                |    2 
 arch/x86/kernel/alternative.c           |    2 
 arch/x86/kernel/cpu/mtrr/generic.c      |    7 +
 arch/x86/kernel/io_apic_32.c            |    3 
 arch/x86/mm/ioremap.c                   |    2 
 drivers/char/drm/i915_dma.c             |    2 
 drivers/char/tty_io.c                   |    2 
 drivers/hwmon/it87.c                    |   39 ++++++++-
 drivers/media/video/bt8xx/bttv-driver.c |    2 
 drivers/media/video/tvaudio.c           |    2 
 drivers/media/video/zoran_driver.c      |    2 
 drivers/net/wireless/b43legacy/xmit.c   |    2 
 drivers/video/console/fbcon.c           |    4 -
 fs/cifs/cifsglob.h                      |    1 
 fs/cifs/cifssmb.c                       |    4 +
 fs/cifs/readdir.c                       |  128 ++++++++++++++++----------------
 fs/splice.c                             |    3 
 kernel/sched_rt.c                       |    8 +-
 18 files changed, 130 insertions(+), 85 deletions(-)

Alan Cox (2):
      x86, early_ioremap: fix fencepost error
      tty: Termios locking - sort out real_tty confusions and lock reads

Arjan van de Ven (1):
      security: avoid calling a NULL function pointer in drivers/video/tvaudio.c

Dario Faggioli (1):
      sched_rt.c: resch needed in rt_rq_enqueue() for the root rt_rq

Greg Kroah-Hartman (1):
      Linux 2.6.25.19

Ingo Molnar (1):
      x86: work around MTRR mask setting, v2

Jean Delvare (3):
      hwmon: (it87) Prevent power-off on Shuttle SN68PT
      V4L: bttv: Prevent NULL pointer dereference in radio_open
      V4L: zr36067: Fix RGBR pixel format

Larry Finger (1):
      b43legacy: Fix failure in rate-adjustment mechanism

Linus Torvalds (1):
      Don't allow splice() to files opened with O_APPEND

Matthias Hopf (1):
      drm/i915: fix ioremap of a user address for non-root (CVE-2008-3831)

Oleg Nesterov (1):
      fbcon_set_all_vcs: fix kernel crash when switching the rotated consoles

Stefan Bader (1):
      x86: Reserve FIRST_DEVICE_VECTOR in used_vectors bitmap.

Steve French (1):
      CIFS: make sure we have the right resume info before calling CIFSFindNext

Thomas Gleixner (1):
      x86: improve UP kernel when CPU-hotplug and SMP is enabled

