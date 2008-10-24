Return-Path: <linux-kernel-owner+w=401wt.eu-S1757465AbYJXFnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465AbYJXFnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 01:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbYJXFnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 01:43:25 -0400
Received: from kroah.org ([198.145.64.141]:59054 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755571AbYJXFnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 01:43:24 -0400
Date: Thu, 23 Oct 2008 22:41:11 -0700
From: Greg KH <greg@kroah.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
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
Subject: Re: [patch 00/27] 2.6.27.4-stable review
Message-ID: <20081024054111.GB17405@kroah.com>
References: <20081024043303.GA30828@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081024043303.GA30828@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 09:33:03PM -0700, Greg KH wrote:
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.4-rc1.gz
> and the diffstat can be found below.

There was a build error in this release, so I've now put up a -rc2
version at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.4-rc2.gz

and the diffstat is below.

thanks,

greg k-h

 Makefile                                       |    2 
 arch/x86/kernel/acpi/sleep.c                   |    3 +
 arch/x86/kernel/amd_iommu_init.c               |    2 
 drivers/acpi/hardware/hwsleep.c                |   37 ++++-----------
 drivers/acpi/sleep/main.c                      |   10 ++++
 drivers/char/hvc_console.c                     |   10 ++--
 drivers/edac/cell_edac.c                       |    2 
 drivers/gpio/gpiolib.c                         |    2 
 drivers/md/dm-kcopyd.c                         |   13 +++++
 drivers/md/dm-snap.c                           |   10 +---
 drivers/net/wireless/ath5k/base.c              |   28 ++++++++---
 drivers/net/wireless/ath5k/base.h              |    3 -
 drivers/pci/hotplug/cpqphp_core.c              |    2 
 drivers/scsi/device_handler/scsi_dh_rdac.c     |    2 
 drivers/usb/atm/speedtch.c                     |   12 +++++
 drivers/usb/class/cdc-acm.c                    |    3 -
 drivers/usb/class/cdc-wdm.c                    |    2 
 drivers/usb/core/driver.c                      |    3 -
 drivers/usb/core/hub.c                         |    2 
 fs/cifs/readdir.c                              |    3 -
 fs/ext2/dir.c                                  |   60 ++++++++++++++-----------
 fs/ext3/dir.c                                  |   10 ++--
 fs/ext4/dir.c                                  |   11 +++-
 fs/proc/task_mmu.c                             |   34 +++++++++-----
 kernel/sched_stats.h                           |    2 
 mm/rmap.c                                      |   42 +++++++++++++----
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    2 
 net/ipv4/netfilter/nf_nat_snmp_basic.c         |    1 
 net/netfilter/xt_iprange.c                     |    8 +--
 29 files changed, 206 insertions(+), 115 deletions(-)
