Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbYKJThe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbYKJThe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 14:37:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750772AbYKJThZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 14:37:25 -0500
Received: from kroah.org ([198.145.64.141]:47210 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750765AbYKJThY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 14:37:24 -0500
Date: Mon, 10 Nov 2008 11:36:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.26.8
Message-ID: <20081110193659.GA27383@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.26.8
kernel.

It is the last release of the 2.6.26.y tree that I have planned to do.
All users using the 2.6.26.y tree are strongly encouraged to upgrade to
this version, and then consider how they are going to upgrade to the
latest 2.6.27 version soon.

I'll also be replying to this message with a copy of the patch between
2.6.26.7 and 2.6.26.8

The updated 2.6.26.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.26.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.26.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                       |    2 
 arch/sparc64/kernel/trampoline.S               |   18 ++-
 drivers/acpi/button.c                          |    3 
 drivers/acpi/dock.c                            |    5 -
 drivers/acpi/video.c                           |  123 ++++++++++++++-----------
 drivers/edac/cell_edac.c                       |    2 
 drivers/gpio/gpiolib.c                         |    2 
 drivers/i2c/busses/scx200_i2c.c                |    1 
 drivers/media/dvb/frontends/s5h1411.c          |   35 +++++--
 drivers/media/video/pvrusb2/pvrusb2-encoder.c  |    4 
 drivers/net/wireless/libertas/scan.c           |    4 
 drivers/scsi/qla2xxx/qla_gs.c                  |    6 +
 fs/ext2/dir.c                                  |   60 +++++++-----
 fs/ext3/dir.c                                  |   10 +-
 fs/ext4/dir.c                                  |   11 +-
 include/linux/sched.h                          |    2 
 include/math-emu/op-common.h                   |   17 ++-
 include/net/scm.h                              |    5 -
 net/core/dev.c                                 |   27 +----
 net/core/rtnetlink.c                           |    2 
 net/core/scm.c                                 |   24 ++++
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    2 
 net/ipv4/netfilter/nf_nat_snmp_basic.c         |    1 
 net/ipv6/tcp_ipv6.c                            |    2 
 net/netfilter/xt_iprange.c                     |    8 -
 security/commoncap.c                           |    6 -
 sound/core/control.c                           |    4 
 27 files changed, 246 insertions(+), 140 deletions(-)

Alexey Dobriyan (1):
      netfilter: xt_iprange: fix range inversion match

Andrea Shepard (1):
      sparc64: Fix race in arch/sparc64/kernel/trampoline.S

Andrew Vasquez (1):
      SCSI: qla2xxx: Skip FDMI registration on ISP21xx/22xx parts.

Benjamin Herrenschmidt (1):
      edac cell: fix incorrect edac_mode

Boris Dores (1):
      V4L: pvrusb2: Keep MPEG PTSs from drifting away

David Brownell (1):
      gpiolib: fix oops in gpio_get_value_cansleep()

David Miller (1):
      net: Fix recursive descent in __scm_destroy().

Devin Heitmueller (2):
      DVB: s5h1411: Perform s5h1411 soft reset after tuning
      DVB: s5h1411: Power down s5h1411 when not in use

Eric Sandeen (1):
      ext[234]: Avoid printk floods in the face of directory corruption (CVE-2008-3528)

Greg Kroah-Hartman (1):
      Linux 2.6.26.8

Guillem Jover (1):
      ACPI: Always report a sync event after a lid state change

Herbert Xu (1):
      net: Fix netdev_run_todo dead-lock

Ilpo Järvinen (2):
      tcpv6: fix option space offsets with md5
      netfilter: snmp nat leaks memory in case of failure

Johannes Berg (1):
      libertas: fix buffer overrun

Julia Jomantaite (1):
      ACPI: video: fix brightness allocation

Kumar Gala (1):
      math-emu: Fix signalling of underflow and inexact while packing result.

Lennart Sorensen (1):
      scx200_i2c: Add missing class parameter

Patrick McHardy (1):
      netfilter: restore lost ifdef guarding defrag exception

Serge Hallyn (1):
      file caps: always start with clear bprm->caps_*

Shaohua Li (1):
      ACPI: dock: avoid check _STA method

Steven Toth (1):
      DVB: s5h1411: bugfix: Setting serial or parallel mode could destroy bits

Takashi Iwai (1):
      ALSA: use correct lock in snd_ctl_dev_disconnect()

