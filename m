Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbZCTXsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbZCTXsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbZCTXsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:48:12 -0400
Received: from kroah.org ([198.145.64.141]:35866 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751049AbZCTXsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:48:10 -0400
Date: Fri, 20 Mar 2009 16:21:16 -0700
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
Subject: [patch 00/43] 2.6.28.9-stable review
Message-ID: <20090320232116.GA3375@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.28.9 release.
There are 43 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the
Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
to add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Monday, March 23, 20:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.28.9-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Makefile                                    |    5 ++-
 arch/ia64/Kconfig                           |    3 +-
 arch/powerpc/sysdev/fsl_soc.c               |    2 +-
 arch/s390/lib/div64.c                       |    2 +-
 arch/x86/include/asm/msr-index.h            |   29 ++++++++++++++++++
 arch/x86/kernel/cpu/intel.c                 |   13 ++++++++
 drivers/ata/ata_piix.c                      |   37 +++++++++++++++++++++++
 drivers/gpu/drm/drm_irq.c                   |   18 +++++++++--
 drivers/gpu/drm/i915/i915_gem.c             |   20 ++++++++----
 drivers/gpu/drm/i915/i915_irq.c             |    6 ++++
 drivers/md/dm-crypt.c                       |   43 +++++++++++++++++++-------
 drivers/md/dm-io.c                          |    2 +
 drivers/md/dm-ioctl.c                       |    3 +-
 drivers/md/dm.c                             |   32 ++++++++++++--------
 drivers/media/video/cx23885/cx23885-417.c   |    3 +-
 drivers/media/video/cx23885/cx23885-video.c |    5 ++-
 drivers/misc/thinkpad_acpi.c                |    8 ++--
 drivers/usb/class/usbtmc.c                  |    4 ++-
 drivers/usb/core/devio.c                    |   12 ++++---
 drivers/usb/host/ehci-q.c                   |    3 +-
 drivers/usb/host/ehci-sched.c               |   10 ++----
 drivers/usb/serial/cp2101.c                 |    1 +
 drivers/usb/serial/ftdi_sio.c               |    5 +++
 drivers/usb/serial/ftdi_sio.h               |   20 ++++++++++++
 drivers/usb/serial/option.c                 |   12 ++++----
 drivers/usb/storage/unusual_devs.h          |   16 +++++++++-
 fs/aio.c                                    |   37 +++++++++++++++++------
 fs/nfsd/nfs4xdr.c                           |    1 +
 include/linux/capability.h                  |    6 ++-
 init/Kconfig                                |   30 +++++++++---------
 sound/core/oss/pcm_oss.c                    |    4 +-
 sound/core/sgbuf.c                          |    7 ++--
 sound/isa/opl3sa2.c                         |   18 +++++++----
 sound/pci/hda/hda_intel.c                   |   39 ++++++++++++++++--------
 sound/pci/mixart/mixart.c                   |    1 +
 35 files changed, 337 insertions(+), 120 deletions(-)
