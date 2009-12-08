Return-Path: <linux-kernel-owner+w=401wt.eu-S965884AbZLHTdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965884AbZLHTdB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 14:33:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965865AbZLHTc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 14:32:57 -0500
Received: from kroah.org ([198.145.64.141]:58229 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965863AbZLHTcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 14:32:55 -0500
Date: Tue, 8 Dec 2009 11:31:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.27.40
Message-ID: <20091208193148.GA20016@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.27.40 kernel.  All users of the
2.6.27 kernel series are very strongly encouraged to upgrade.

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                  |    2 
 arch/x86/kernel/acpi/processor.c          |    3 
 drivers/dca/dca-core.c                    |   51 ++++++++++-----
 drivers/hwmon/it87.c                      |    2 
 drivers/isdn/hisax/hfc_usb.c              |    4 -
 drivers/media/common/tuners/tda18271-fe.c |    8 +-
 drivers/media/dvb/frontends/dib7000p.c    |    5 +
 drivers/media/video/em28xx/em28xx-audio.c |    5 +
 drivers/media/video/s2255drv.c            |    5 -
 drivers/misc/thinkpad_acpi.c              |    2 
 drivers/scsi/gdth.c                       |    2 
 drivers/usb/host/ohci-hcd.c               |    5 +
 drivers/usb/host/ohci-pci.c               |   20 ++++++
 drivers/usb/host/ohci-q.c                 |   18 +++--
 drivers/usb/host/ohci.h                   |    9 ++
 drivers/usb/serial/aircable.c             |    5 -
 drivers/usb/serial/belkin_sa.c            |    7 --
 drivers/usb/serial/cp2101.c               |    6 -
 drivers/usb/serial/cyberjack.c            |   20 ++++--
 drivers/usb/serial/cypress_m8.c           |   11 +--
 drivers/usb/serial/digi_acceleport.c      |   20 ++++--
 drivers/usb/serial/empeg.c                |    8 --
 drivers/usb/serial/ftdi_sio.c             |   14 ----
 drivers/usb/serial/garmin_gps.c           |   16 ++++
 drivers/usb/serial/generic.c              |    9 ++
 drivers/usb/serial/io_edgeport.c          |   29 ++++++--
 drivers/usb/serial/io_tables.h            |   12 ++-
 drivers/usb/serial/io_ti.c                |   22 +++++-
 drivers/usb/serial/ipaq.c                 |    7 --
 drivers/usb/serial/iuu_phoenix.c          |    6 -
 drivers/usb/serial/keyspan.c              |   13 +++-
 drivers/usb/serial/keyspan.h              |   12 ++-
 drivers/usb/serial/keyspan_pda.c          |    4 -
 drivers/usb/serial/kl5kusb105.c           |   39 ++++++------
 drivers/usb/serial/kobil_sct.c            |   12 +--
 drivers/usb/serial/mct_u232.c             |   13 +---
 drivers/usb/serial/mos7720.c              |    9 --
 drivers/usb/serial/mos7840.c              |   48 ++++++++++++--
 drivers/usb/serial/omninet.c              |   19 ++++-
 drivers/usb/serial/option.c               |   97 +++++++++++++++++++++++++++---
 drivers/usb/serial/oti6858.c              |    7 --
 drivers/usb/serial/pl2303.c               |    5 -
 drivers/usb/serial/sierra.c               |   28 +++++++-
 drivers/usb/serial/spcp8x5.c              |    5 -
 drivers/usb/serial/ti_usb_3410_5052.c     |   10 +--
 drivers/usb/serial/usb-serial.c           |   29 ++++----
 drivers/usb/serial/visor.c                |   13 +---
 drivers/usb/serial/whiteheat.c            |    6 -
 fs/fuse/dir.c                             |    3 
 fs/fuse/file.c                            |    3 
 fs/jffs2/read.c                           |    9 +-
 include/linux/usb/serial.h                |   12 ++-
 sound/arm/aaci.c                          |    6 +
 sound/usb/usbaudio.h                      |    2 
 54 files changed, 493 insertions(+), 244 deletions(-)

Alan Stern (1):
      USB: usb-serial: replace shutdown with disconnect, release

Anand V. Avati (1):
      fuse: prevent fuse_put_request on invalid pointer

Csaba Henk (1):
      fuse: reject O_DIRECT flag also in fuse_create

Dave Jones (1):
      gdth: Prevent negative offsets in ioctl CVE-2009-3080

David Woodhouse (1):
      jffs2: Fix memory corruption in jffs2_read_inode_range()

Devin Heitmueller (1):
      V4L/DVB (13190): em28xx: fix panic that can occur when starting audio streaming

Greg Kroah-Hartman (1):
      Linux 2.6.27.40

Harald Welte (1):
      Enable ACPI PDC handshake for VIA/Centaur CPUs

Jean Delvare (1):
      hwmon: (it87) Fix VID reading on IT8718F

Julian Anastasov (1):
      ALSA: usb-audio: fix combine_word problem

Libin Yang (1):
      USB: ohci: quirk AMD prefetch for USB 1.1 ISO transfer

Maciej Sosnowski (1):
      dca: redesign locks to fix deadlocks

Martin Samek (1):
      V4L/DVB (13079): dib0700: fixed xc2028 firmware loading kernel oops

Michael Krufky (1):
      V4L/DVB (13107): tda18271: fix overflow in FM radio frequency calculation

Mike Isely (1):
      V4L/DVB (13230): s2255drv: Don't conditionalize video buffer completion on waiting processes

Oliver Neukum (1):
      USB: suspend/resume support for option driver

Roel Kluin (2):
      isdn: hfc_usb: Fix read buffer overflow
      thinkpad-acpi: fix sign of ERESTARTSYS return

Russell King (2):
      ALSA: AACI: fix AC97 multiple-open bug
      ALSA: AACI: fix recording bug

Seth Barry (1):
      V4L/DVB (13109): tda18271: fix signedness issue in tda18271_rf_tracking_filters_init

