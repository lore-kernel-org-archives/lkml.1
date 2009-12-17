Return-Path: <linux-kernel-owner+w=401wt.eu-S1763511AbZLQA6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763511AbZLQA6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 19:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763219AbZLQA6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 19:58:24 -0500
Received: from kroah.org ([198.145.64.141]:44481 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756529AbZLQAyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 19:54:35 -0500
Date: Wed, 16 Dec 2009 16:53:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/18] 2.6.27.42-stable review
Message-ID: <20091217005306.GA6230@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.27.42 release.
There are 18 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Friday, December 19, 00:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.42-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h

-------------

 Makefile                               |    2 +-
 arch/ia64/lib/ip_fast_csum.S           |    8 +++--
 arch/x86/kernel/cpu/perfctr-watchdog.c |    2 +-
 arch/x86/kernel/pci-calgary_64.c       |   12 ++++---
 arch/x86/kernel/pci-dma.c              |    2 +-
 arch/x86/kernel/pci-gart_64.c          |    2 +-
 arch/x86/kernel/reboot.c               |    8 +++++
 drivers/ata/pata_hpt37x.c              |   32 +++++++++----------
 drivers/ata/pata_hpt3x2n.c             |   17 +++++-----
 drivers/firewire/fw-ohci.c             |   12 ++++++-
 drivers/media/common/tuners/mxl5007t.c |    2 +-
 drivers/ssb/sprom.c                    |   20 +++++++++--
 drivers/usb/serial/mos7840.c           |   21 ++++++++----
 drivers/video/backlight/lcd.c          |    2 +-
 drivers/video/matrox/g450_pll.c        |    3 +-
 fs/debugfs/inode.c                     |   55 ++++++++++++++++++-------------
 fs/fuse/dir.c                          |    3 ++
 fs/hfs/catalog.c                       |    4 ++
 fs/hfs/dir.c                           |   11 ++++++
 fs/hfs/super.c                         |    7 +++-
 fs/jffs2/gc.c                          |    3 +-
 include/linux/sched.h                  |   13 ++++++--
 22 files changed, 159 insertions(+), 82 deletions(-)
