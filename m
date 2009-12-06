Return-Path: <linux-kernel-owner+w=401wt.eu-S1758248AbZLFXkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248AbZLFXkG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 18:40:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758159AbZLFXjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 18:39:52 -0500
Received: from kroah.org ([198.145.64.141]:33873 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758139AbZLFXju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 18:39:50 -0500
Date: Sun, 6 Dec 2009 15:37:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/20] 2.6.27.40-stable review
Message-ID: <20091206233711.GA11609@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the start of the stable review cycle for the 2.6.27.40 release.
There are 20 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Tuesday Dec 8, 20:00:00 UTC.  Anything
received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.40-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Makefile                                  |    2 +-
 arch/x86/kernel/acpi/processor.c          |    3 +-
 drivers/dca/dca-core.c                    |   51 ++++++++++-----
 drivers/hwmon/it87.c                      |    2 +-
 drivers/isdn/hisax/hfc_usb.c              |    4 +-
 drivers/media/common/tuners/tda18271-fe.c |    8 +-
 drivers/media/dvb/frontends/dib7000p.c    |    5 ++
 drivers/media/video/em28xx/em28xx-audio.c |    5 ++
 drivers/media/video/s2255drv.c            |    5 --
 drivers/misc/thinkpad_acpi.c              |    2 +-
 drivers/scsi/gdth.c                       |    2 +-
 drivers/usb/host/ohci-hcd.c               |    5 ++
 drivers/usb/host/ohci-pci.c               |   20 ++++++
 drivers/usb/host/ohci-q.c                 |   18 ++++--
 drivers/usb/host/ohci.h                   |    9 +++
 drivers/usb/serial/aircable.c             |    5 +-
 drivers/usb/serial/belkin_sa.c            |    7 +-
 drivers/usb/serial/cp2101.c               |    6 +-
 drivers/usb/serial/cyberjack.c            |   20 +++++--
 drivers/usb/serial/cypress_m8.c           |   11 ++--
 drivers/usb/serial/digi_acceleport.c      |   20 +++++--
 drivers/usb/serial/empeg.c                |    8 ---
 drivers/usb/serial/ftdi_sio.c             |   14 ----
 drivers/usb/serial/garmin_gps.c           |   16 ++++-
 drivers/usb/serial/generic.c              |    9 ++-
 drivers/usb/serial/io_edgeport.c          |   29 ++++++---
 drivers/usb/serial/io_tables.h            |   12 +++-
 drivers/usb/serial/io_ti.c                |   22 +++++--
 drivers/usb/serial/ipaq.c                 |    7 --
 drivers/usb/serial/iuu_phoenix.c          |    6 +-
 drivers/usb/serial/keyspan.c              |   13 ++++-
 drivers/usb/serial/keyspan.h              |   12 +++-
 drivers/usb/serial/keyspan_pda.c          |    4 +-
 drivers/usb/serial/kl5kusb105.c           |   39 +++++++-----
 drivers/usb/serial/kobil_sct.c            |   12 +---
 drivers/usb/serial/mct_u232.c             |   13 ++---
 drivers/usb/serial/mos7720.c              |    9 +--
 drivers/usb/serial/mos7840.c              |   48 ++++++++++++---
 drivers/usb/serial/omninet.c              |   19 +++++-
 drivers/usb/serial/option.c               |   97 ++++++++++++++++++++++++++---
 drivers/usb/serial/oti6858.c              |    7 +-
 drivers/usb/serial/pl2303.c               |    5 +-
 drivers/usb/serial/sierra.c               |   28 +++++++-
 drivers/usb/serial/spcp8x5.c              |    5 +-
 drivers/usb/serial/ti_usb_3410_5052.c     |   10 +--
 drivers/usb/serial/usb-serial.c           |   29 ++++-----
 drivers/usb/serial/visor.c                |   13 ++---
 drivers/usb/serial/whiteheat.c            |    6 +-
 fs/fuse/dir.c                             |    3 +
 fs/fuse/file.c                            |    3 +-
 fs/jffs2/read.c                           |    9 ++-
 include/linux/usb/serial.h                |   12 +++-
 sound/arm/aaci.c                          |    6 ++-
 sound/usb/usbaudio.h                      |    2 +-
 54 files changed, 493 insertions(+), 244 deletions(-)
