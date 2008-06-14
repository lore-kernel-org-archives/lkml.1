Return-Path: <linux-kernel-owner+w=401wt.eu-S1759564AbYFNAKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564AbYFNAKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:10:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757558AbYFNAJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:09:58 -0400
Received: from ns1.suse.de ([195.135.220.2]:33930 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757554AbYFNAJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:09:57 -0400
Date: Fri, 13 Jun 2008 17:08:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: [patch 00/47] 2.6.25-stable review
Message-ID: <20080614000840.GA24659@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.25.7 release.
There are 47 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Monday, Jun 16, 20:00:00 UTC.  Anything
received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.25.7-rc1.gz
and the diffstat can be found below.


thanks,

the -stable release team

----------


 Documentation/cciss.txt                   |    5 +
 Makefile                                  |    2 
 arch/x86/Kconfig                          |   23 +----
 drivers/block/brd.c                       |    1 
 drivers/block/cciss.c                     |   21 +++--
 drivers/char/pcmcia/ipwireless/hardware.c |   20 ++--
 drivers/cpufreq/cpufreq.c                 |    2 
 drivers/infiniband/core/umem.c            |    2 
 drivers/media/video/bt8xx/bttv-driver.c   |    2 
 drivers/media/video/videobuf-core.c       |    3 
 drivers/mmc/host/wbsd.c                   |   21 ++---
 drivers/net/cassini.c                     |   11 +-
 drivers/net/forcedeth.c                   |   20 ++++
 drivers/net/pppol2tp.c                    |  124 +++++++++++++++++++++++-------
 drivers/net/wireless/b43/main.c           |   12 ++
 drivers/serial/serial_core.c              |    5 -
 drivers/serial/sunhv.c                    |    1 
 drivers/ssb/driver_pcicore.c              |    4 
 drivers/video/hgafb.c                     |   26 +++---
 drivers/video/modedb.c                    |    1 
 fs/cifs/cifsfs.c                          |   21 ++---
 fs/ecryptfs/crypto.c                      |    2 
 fs/ecryptfs/file.c                        |    2 
 fs/ecryptfs/inode.c                       |   15 +--
 fs/pipe.c                                 |    3 
 include/asm-m68k/bitops.h                 |   46 ++++++++++-
 include/linux/pci_ids.h                   |    1 
 include/media/videobuf-core.h             |    3 
 include/net/netlink.h                     |   11 +-
 init/Kconfig                              |    1 
 net/8021q/vlan.c                          |    4 
 net/ax25/ax25_subr.c                      |   11 --
 net/bluetooth/rfcomm/core.c               |    2 
 net/can/raw.c                             |   21 ++---
 net/core/dev.c                            |    2 
 net/ipv4/route.c                          |    2 
 net/ipv4/tcp_cong.c                       |   12 +-
 net/ipv4/tcp_input.c                      |   65 ++++++++++-----
 net/ipv4/tcp_output.c                     |   10 +-
 net/ipv6/route.c                          |    2 
 net/key/af_key.c                          |    2 
 net/mac80211/ieee80211_sta.c              |    5 +
 net/sched/cls_api.c                       |    2 
 sound/pci/emu10k1/emu10k1_main.c          |   15 +--
 sound/pci/hda/patch_realtek.c             |    1 
 45 files changed, 375 insertions(+), 192 deletions(-)
