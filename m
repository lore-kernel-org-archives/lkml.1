Return-Path: <linux-kernel-owner+w=401wt.eu-S1753818Ab0AUEWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab0AUEWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 23:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915Ab0AUEWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 23:22:20 -0500
Received: from kroah.org ([198.145.64.141]:60047 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151Ab0AUEWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 23:22:19 -0500
Date: Wed, 20 Jan 2010 20:18:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/30] 2.6.32.5 review
Message-ID: <20100121041852.GA9656@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.32.5 release.
There are 30 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Saturday, January 23, 2010 00:00:00 @ UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.32.5-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                                 |    2 +-
 arch/powerpc/kernel/pci-common.c         |   13 +++++++++
 arch/sparc/kernel/nmi.c                  |    3 +-
 arch/sparc/kernel/perf_event.c           |   11 +++++++
 arch/x86/kernel/apic/apic_flat_64.c      |    5 +++
 arch/x86/kernel/apic/x2apic_uv_x.c       |   15 +++++-----
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    5 ++-
 drivers/edac/i5000_edac.c                |    8 +++++-
 drivers/gpu/drm/i915/i915_irq.c          |   43 ++++++++++++-----------------
 drivers/hid/hid-apple.c                  |    7 +++++
 drivers/hid/hid-core.c                   |    3 ++
 drivers/hid/hid-ids.h                    |    3 ++
 drivers/i2c/busses/i2c-pca-isa.c         |    4 +-
 drivers/i2c/busses/i2c-pca-platform.c    |    4 +-
 drivers/i2c/i2c-core.c                   |    5 ++-
 drivers/input/mouse/psmouse-base.c       |   28 ++++++++++---------
 drivers/media/video/gspca/sn9c20x.c      |    2 +-
 drivers/mfd/wm8350-core.c                |    3 +-
 drivers/pci/pci.c                        |    5 +++
 drivers/pcmcia/cardbus.c                 |    2 +-
 drivers/platform/x86/asus-laptop.c       |    8 +++++
 drivers/scsi/megaraid/megaraid_sas.c     |    2 +-
 drivers/serial/8250_pnp.c                |    2 +
 drivers/video/s3c-fb.c                   |   14 +++++----
 fs/notify/inotify/inotify_fsnotify.c     |    2 +-
 fs/notify/inotify/inotify_user.c         |    4 +-
 fs/reiserfs/inode.c                      |   17 +++++++++--
 include/linux/blkdev.h                   |   11 ++++++-
 include/linux/mfd/wm8350/pmic.h          |   28 +++++++++---------
 include/linux/pci.h                      |    3 ++
 kernel/futex.c                           |   27 ++++++++----------
 kernel/sched.c                           |    6 ----
 kernel/sched_clock.c                     |   23 ++++++++++-----
 mm/memcontrol.c                          |   11 +++-----
 mm/page_alloc.c                          |    2 +-
 mm/truncate.c                            |   30 +++++++++-----------
 sound/pci/hda/patch_realtek.c            |    2 +
 37 files changed, 221 insertions(+), 142 deletions(-)
