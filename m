Return-Path: <linux-kernel-owner+w=401wt.eu-S1762984AbZCTXZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762984AbZCTXZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761340AbZCTXPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:15:34 -0400
Received: from kroah.org ([198.145.64.141]:46872 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761288AbZCTXPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:15:33 -0400
Date: Fri, 20 Mar 2009 16:10:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: [patch 00/32] 2.6.27.21-stable review
Message-ID: <20090320231037.GA2732@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.27.21 release.
There are 32 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Monday, March 23, 20:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
        kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.21-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                                    |    5 +++-
 arch/ia64/Kconfig                           |    3 +-
 arch/powerpc/sysdev/fsl_soc.c               |    2 +-
 arch/s390/lib/div64.c                       |    2 +-
 arch/x86/kernel/cpu/intel.c                 |   13 +++++++++
 arch/x86/kernel/cpu/intel_64.c              |   13 +++++++++
 drivers/ata/ata_piix.c                      |   37 +++++++++++++++++++++++++++
 drivers/md/dm-crypt.c                       |   26 +++++++++++++++---
 drivers/md/dm-io.c                          |    2 +
 drivers/md/dm-ioctl.c                       |    3 +-
 drivers/media/video/cx23885/cx23885-417.c   |    3 +-
 drivers/media/video/cx23885/cx23885-video.c |    5 ++-
 drivers/misc/thinkpad_acpi.c                |    8 +++---
 drivers/usb/core/devio.c                    |   12 +++++---
 drivers/usb/host/ehci-q.c                   |    3 +-
 drivers/usb/host/ehci-sched.c               |   10 +++----
 drivers/usb/serial/cp2101.c                 |    1 +
 drivers/usb/serial/ftdi_sio.c               |    5 +++
 drivers/usb/serial/ftdi_sio.h               |   20 ++++++++++++++
 drivers/usb/serial/option.c                 |   12 ++++----
 drivers/usb/storage/unusual_devs.h          |   16 ++++++++++-
 fs/aio.c                                    |   37 +++++++++++++++++++-------
 fs/nfsd/nfs4xdr.c                           |    1 +
 include/asm-x86/msr-index.h                 |   29 +++++++++++++++++++++
 include/linux/capability.h                  |    6 +++-
 sound/core/oss/pcm_oss.c                    |    4 +-
 sound/core/sgbuf.c                          |    7 +++--
 sound/pci/hda/hda_intel.c                   |    8 ++++++
 sound/pci/mixart/mixart.c                   |    1 +
 29 files changed, 239 insertions(+), 55 deletions(-)
