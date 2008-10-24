Return-Path: <linux-kernel-owner+w=401wt.eu-S1752629AbYJXEjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbYJXEjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 00:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbYJXEjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 00:39:03 -0400
Received: from kroah.org ([198.145.64.141]:51582 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751085AbYJXEjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 00:39:00 -0400
Date: Thu, 23 Oct 2008 21:33:03 -0700
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
Subject: [patch 00/27] 2.6.27.4-stable review
Message-ID: <20081024043303.GA30828@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.27.4 release.
There are 27 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Sunday, October 26 04:00:00 UTC.  Anything
received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.4-rc1.gz
and the diffstat can be found below.

thanks,

the -stable release team

 arch/x86/kernel/acpi/sleep.c                   |    3 
 arch/x86/kernel/amd_iommu_init.c               |    2 
 drivers/acpi/hardware/hwsleep.c                |   37 ++------
 drivers/acpi/sleep/main.c                      |   10 ++
 drivers/char/hvc_console.c                     |   10 +-
 drivers/edac/cell_edac.c                       |    2 
 drivers/gpio/gpiolib.c                         |    2 
 drivers/md/dm-exception-store.c                |  106 +++++++++++++++++--------
 drivers/md/dm-kcopyd.c                         |   13 ++-
 drivers/md/dm-snap.c                           |   10 --
 drivers/net/wireless/ath5k/base.c              |   28 ++++--
 drivers/net/wireless/ath5k/base.h              |    3 
 drivers/pci/hotplug/cpqphp_core.c              |    2 
 drivers/scsi/device_handler/scsi_dh_rdac.c     |    2 
 drivers/usb/atm/speedtch.c                     |   12 ++
 drivers/usb/class/cdc-acm.c                    |    3 
 drivers/usb/class/cdc-wdm.c                    |    2 
 drivers/usb/core/driver.c                      |    3 
 drivers/usb/core/hub.c                         |    2 
 fs/cifs/readdir.c                              |    3 
 fs/ext2/dir.c                                  |   60 ++++++++------
 fs/ext3/dir.c                                  |   10 +-
 fs/ext4/dir.c                                  |   11 +-
 fs/proc/task_mmu.c                             |   34 +++++---
 kernel/sched_stats.h                           |    2 
 mm/rmap.c                                      |   42 +++++++--
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    2 
 net/ipv4/netfilter/nf_nat_snmp_basic.c         |    1 
 net/netfilter/xt_iprange.c                     |    8 -
 29 files changed, 278 insertions(+), 147 deletions(-)
