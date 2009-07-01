Return-Path: <linux-kernel-owner+w=401wt.eu-S1758564AbZGAA3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564AbZGAA3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756456AbZGAA2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:28:45 -0400
Received: from kroah.org ([198.145.64.141]:34269 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757948AbZGAA2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:28:44 -0400
Date: Tue, 30 Jun 2009 17:28:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 00/30] 2.6.27-stable review
Message-ID: <20090701002817.GA6156@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.27.26 release.
There are 30 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Friday, Jul 3, 00:00:00 2009 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.26-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h

 Makefile                         |    2 +-
 arch/x86/kernel/reboot.c         |   18 ++++++++
 arch/x86/kernel/setup.c          |   15 +-----
 drivers/block/floppy.c           |   87 ++++++++++++++++++++++++++------------
 drivers/char/moxa.c              |    7 +++-
 drivers/char/mxser.c             |    2 +-
 drivers/char/pcmcia/cm4000_cs.c  |    3 +-
 drivers/firmware/memmap.c        |   16 ++++---
 drivers/infiniband/hw/mlx4/qp.c  |    4 ++
 drivers/isdn/hisax/hfc_pci.c     |   41 +++++++++++++-----
 drivers/isdn/hisax/hisax.h       |    2 +-
 drivers/md/dm-mpath.c            |   11 +++++
 drivers/md/dm.c                  |    4 ++
 drivers/md/raid5.c               |    1 +
 drivers/net/bonding/bond_sysfs.c |    1 +
 drivers/net/r8169.c              |   11 ++---
 drivers/parport/parport_pc.c     |   34 ++++++++++++---
 drivers/parport/parport_serial.c |   30 +++++++++++--
 drivers/pci/pci.c                |    7 ++-
 drivers/pci/pcie/aspm.c          |    4 ++
 drivers/video/atmel_lcdfb.c      |   10 +----
 fs/jbd/commit.c                  |    6 ++-
 include/linux/firmware-map.h     |   12 ++----
 include/linux/mlx4/qp.h          |    1 +
 lib/Kconfig.debug                |    2 +-
 mm/page_alloc.c                  |    6 ++-
 net/ipv4/tcp_ipv4.c              |    4 ++
 net/ipv4/tcp_output.c            |   13 ++++-
 sound/core/seq/seq_midi_event.c  |    8 ++--
 sound/pci/ca0106/ca0106_mixer.c  |    6 +++
 30 files changed, 258 insertions(+), 110 deletions(-)
