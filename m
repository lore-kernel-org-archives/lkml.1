Return-Path: <linux-kernel-owner+w=401wt.eu-S1756728AbYGNIPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728AbYGNIPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 04:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754976AbYGNIPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 04:15:06 -0400
Received: from isilmar.linta.de ([213.133.102.198]:53049 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753541AbYGNIPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 04:15:05 -0400
Date: Mon, 14 Jul 2008 10:10:47 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [git pull] PCMCIA updates and fixes for 2.6.27
Message-ID: <20080714081047.GA11077@comet.dominikbrodowski.net>
Mail-Followup-To: torvalds@osdl.org, akpm@osdl.org,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The PCMCIA updates for 2.6.27 are available at

        git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6/

Please pull from that location. The diffstat and list of changes follows,
the individual diffs are sent (at least) to the linux-pcmcia list.

Thanks,
        Dominik

----

 drivers/char/pcmcia/cm4000_cs.c       |  118 +++++++----
 drivers/char/pcmcia/cm4040_cs.c       |   23 +-
 drivers/char/pcmcia/ipwireless/main.c |    1 
 drivers/ide/legacy/ide-cs.c           |   10 -
 drivers/mtd/ftl.c                     |    4 
 drivers/mtd/maps/pcmciamtd.c          |    9 
 drivers/pcmcia/Kconfig                |    7 
 drivers/pcmcia/Makefile               |    1 
 drivers/pcmcia/au1000_generic.h       |   27 +-
 drivers/pcmcia/au1000_pb1x00.c        |    1 
 drivers/pcmcia/au1000_xxs1500.c       |    1 
 drivers/pcmcia/bfin_cf_pcmcia.c       |  339 ++++++++++++++++++++++++++++++++++
 drivers/pcmcia/cardbus.c              |    2 
 drivers/pcmcia/cistpl.c               |   16 -
 drivers/pcmcia/cs.c                   |   14 -
 drivers/pcmcia/cs_internal.h          |   13 -
 drivers/pcmcia/ds.c                   |   12 -
 drivers/pcmcia/hd64465_ss.c           |    3 
 drivers/pcmcia/i82092.c               |    2 
 drivers/pcmcia/i82092aa.h             |    2 
 drivers/pcmcia/i82365.c               |   39 ++-
 drivers/pcmcia/m8xx_pcmcia.c          |    3 
 drivers/pcmcia/pcmcia_ioctl.c         |  154 +++++++++++++++
 drivers/pcmcia/pcmcia_resource.c      |   81 +-------
 drivers/pcmcia/pxa2xx_base.c          |    1 
 drivers/pcmcia/rsrc_mgr.c             |   86 --------
 drivers/pcmcia/rsrc_nonstatic.c       |   57 +----
 drivers/pcmcia/soc_common.h           |    1 
 drivers/pcmcia/socket_sysfs.c         |    8 
 drivers/pcmcia/ti113x.h               |    4 
 include/pcmcia/bulkmem.h              |   41 ----
 include/pcmcia/cistpl.h               |    2 
 include/pcmcia/cs.h                   |    3 
 include/pcmcia/cs_types.h             |    6 
 include/pcmcia/ds.h                   |   19 +
 include/pcmcia/ss.h                   |   12 -
 include/pcmcia/version.h              |    3 
 37 files changed, 722 insertions(+), 403 deletions(-)
----
Adrian Bunk (2):
      pcmcia: remove CVS keywords
      pcmcia: kill IN_CARD_SERVICES

Alan Cox (2):
      pcmcia: switch cm4000_cs.c to unlocked_ioctl
      pcmcia: irq probe can be done without risking an IRQ storm

Alex Harford (1):
      pcmcia: Fix ti12xx_2nd_slot_empty always failing

Christoph Hellwig (1):
      pcmcia: cs: kill thread_wait

David Brownell (1):
      pcmcia: simplify rsrc_nonstatic attributes

Dominik Brodowski (6):
      pcmcia: remove version.h
      pcmcia: check for pointer instead of pointer address
      pcmcia: carve out ioctl adjust function to pcmcia_ioctl
      pcmcia: simplify pccard_validate_cis
      pcmcia: (re)move {pcmcia,pccard}_get_status
      pcmcia: allow for longer CIS firmware files

Jonathan Corbet (1):
      pcmcia: cm40x0 cdev lock_kernel() pushdown

Larry Finger (2):
      pcmcia: ide-cs debugging bugfix
      pcmcia: Fix ide-cs sparse warning

Leonardo Potenza (1):
      pcmcia: i82365.c: check request_irq return value

Magnus Damm (3):
      pcmcia: Update email address for m8xx driver author
      pcmcia: remove unused bulkmem.h
      pcmcia: Remove unused header file code

Michael Hennerich (1):
      pcmcia: add support CompactFlash PCMCIA support for Blackfin.

Roel Kluin (1):
      pcmcia: yenta-cardbus: ENE_TEST_C9_PFENABLE duplicate *_F0

Sergei Shtylyov (1):
      pcmcia: fix Alchemy warnings

