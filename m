Return-Path: <linux-kernel-owner+w=401wt.eu-S1755068AbZGASi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbZGASi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 14:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbZGASiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 14:38:18 -0400
Received: from kroah.org ([198.145.64.141]:46752 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065AbZGASiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 14:38:18 -0400
Date: Wed, 1 Jul 2009 11:35:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/30] 2.6.27-stable review
Message-ID: <20090701183548.GA14064@kroah.com>
References: <20090701002817.GA6156@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701002817.GA6156@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 05:28:17PM -0700, Greg KH wrote:
> This is the start of the stable review cycle for the 2.6.27.26 release.

And there's a -rc2 for this tree as well.  2 more patches were added.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.26-rc2.gz
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
 kernel/acct.c                    |    6 ++-
 lib/Kconfig.debug                |    2 +-
 mm/page_alloc.c                  |    6 ++-
 net/ipv4/tcp_ipv4.c              |    4 ++
 net/ipv4/tcp_output.c            |   13 ++++-
 scripts/unifdef.c                |    6 +-
 sound/core/seq/seq_midi_event.c  |    8 ++--
 sound/pci/ca0106/ca0106_mixer.c  |    6 +++
 32 files changed, 265 insertions(+), 115 deletions(-)
