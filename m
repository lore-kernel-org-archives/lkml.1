Return-Path: <linux-kernel-owner+w=401wt.eu-S1754306AbYJRTKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbYJRTKJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:10:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbYJRTD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:03:56 -0400
Received: from ns.suse.de ([195.135.220.2]:38285 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945AbYJRTDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:03:54 -0400
Date: Sat, 18 Oct 2008 11:47:08 -0700
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
Subject: [patch 00/26] 2.6.26-stable review
Message-ID: <20081018184708.GA301@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.26.7 release.
There are 26 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the
Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
to add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Wed, October 22, 2008 19:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.26.7-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h


 Documentation/video4linux/CARDLIST.au0828 |    2 
 Makefile                                  |    2 
 arch/x86/kernel/alternative.c             |    2 
 arch/x86/kernel/io_apic_32.c              |    3 
 arch/x86/kernel/process_64.c              |    4 
 arch/x86/mm/ioremap.c                     |    2 
 drivers/acpi/video.c                      |   14 ++-
 drivers/ata/libata-eh.c                   |   24 +----
 drivers/char/drm/i915_dma.c               |    2 
 drivers/char/tty_io.c                     |    2 
 drivers/hwmon/it87.c                      |   39 +++++++--
 drivers/media/video/au0828/au0828-cards.c |    3 
 drivers/media/video/bt8xx/bttv-driver.c   |    2 
 drivers/media/video/uvc/uvc_ctrl.c        |   44 +++++++---
 drivers/media/video/uvc/uvc_video.c       |   33 +++++--
 drivers/media/video/zoran_driver.c        |    2 
 drivers/net/wireless/b43legacy/xmit.c     |    2 
 drivers/pci/pci-acpi.c                    |    7 +
 drivers/pci/pci-sysfs.c                   |   19 ++++
 drivers/pci/pcie/aspm.c                   |   18 ++++
 drivers/pci/probe.c                       |    3 
 drivers/video/console/fbcon.c             |    4 
 fs/cifs/cifsglob.h                        |    1 
 fs/cifs/cifssmb.c                         |    4 
 fs/cifs/readdir.c                         |  128 +++++++++++++++---------------
 fs/splice.c                               |    3 
 include/acpi/actbl.h                      |    1 
 include/linux/ata.h                       |    2 
 include/linux/pci-aspm.h                  |    5 +
 include/linux/pci_regs.h                  |    1 
 kernel/module.c                           |    2 
 kernel/sched_rt.c                         |    8 -
 32 files changed, 258 insertions(+), 130 deletions(-)
