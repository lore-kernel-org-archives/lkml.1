Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425Ab0AWA1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425Ab0AWA1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754884Ab0AWA1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:27:24 -0500
Received: from kroah.org ([198.145.64.141]:35037 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570Ab0AWASp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:18:45 -0500
Date: Fri, 22 Jan 2010 16:11:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/29] 2.6.32.6 stable review
Message-ID: <20100123001145.GA7391@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.32.6 release.
There are 29 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Monday, January 24, 00:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.32.6-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                              |    2 +-
 arch/x86/kernel/cpuid.c               |    5 +-
 arch/x86/kernel/msr.c                 |    4 +-
 arch/x86/pci/i386.c                   |    9 +++
 block/blk-settings.c                  |   22 ++++++
 drivers/acpi/ec.c                     |  125 +++++++++++++++++++++------------
 drivers/char/nozomi.c                 |    2 +-
 drivers/char/tty_io.c                 |    2 +-
 drivers/gpu/drm/i915/intel_sdvo.c     |   83 +++++++++++++++++++++-
 drivers/md/dm-table.c                 |   20 ++----
 drivers/media/video/gspca/sunplus.c   |   26 ++++----
 drivers/misc/enclosure.c              |    1 +
 drivers/serial/8250_pnp.c             |   10 +---
 drivers/staging/asus_oled/asus_oled.c |   12 ++-
 drivers/staging/hv/Hv.c               |   50 +++++++-------
 drivers/staging/hv/Hv.h               |    6 +-
 drivers/staging/hv/Vmbus.c            |   12 ++--
 drivers/usb/core/devices.c            |    2 +-
 drivers/usb/core/hub.c                |    3 +
 drivers/usb/core/message.c            |    8 +-
 drivers/usb/core/sysfs.c              |    6 ++
 drivers/usb/host/ehci-hcd.c           |    5 +-
 drivers/usb/host/ehci-hub.c           |   20 +++++-
 drivers/usb/host/ehci-q.c             |   11 ++-
 drivers/usb/host/uhci-hcd.c           |   15 ++++-
 drivers/usb/host/uhci-hub.c           |    2 +-
 drivers/usb/serial/generic.c          |    2 +
 drivers/usb/storage/unusual_devs.h    |    7 --
 drivers/usb/storage/usb.c             |    3 +-
 fs/ecryptfs/crypto.c                  |    4 +-
 fs/ecryptfs/file.c                    |   14 ++--
 include/linux/blkdev.h                |    2 +
 include/linux/enclosure.h             |    2 +
 kernel/perf_event.c                   |   29 +++++++-
 mm/vmalloc.c                          |    4 +-
 tools/perf/builtin-timechart.c        |    2 +-
 36 files changed, 365 insertions(+), 167 deletions(-)
