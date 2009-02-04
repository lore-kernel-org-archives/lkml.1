Return-Path: <linux-kernel-owner+w=401wt.eu-S1758382AbZBDShV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758382AbZBDShV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:37:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755103AbZBDSg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:36:58 -0500
Received: from kroah.org ([198.145.64.141]:50855 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751682AbZBDSg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:36:57 -0500
Date: Wed, 4 Feb 2009 10:34:03 -0800
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
Subject: [patch 00/33] 2.6.28-stable review
Message-ID: <20090204183403.GA13936@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.28.4 release.
There are 33 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Friday, February 6, 19:00:00 UTC.  Anything
received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.28.4-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h

 Makefile                                   |    2 +-
 arch/m68knommu/Kconfig                     |    4 +
 arch/x86/kernel/acpi/cstate.c              |    4 +-
 arch/x86/lib/usercopy_32.c                 |    4 +-
 arch/x86/lib/usercopy_64.c                 |    4 +-
 arch/x86/pci/irq.c                         |    1 +
 drivers/acpi/battery.c                     |    5 +-
 drivers/acpi/namespace/nsutils.c           |    8 ++-
 drivers/acpi/pci_link.c                    |    4 -
 drivers/acpi/video.c                       |    5 +
 drivers/ata/sata_mv.c                      |    6 +-
 drivers/ata/sata_nv.c                      |   77 +++++++++-----
 drivers/char/selection.c                   |    2 +-
 drivers/cpuidle/governors/menu.c           |   10 ++-
 drivers/input/keyboard/atkbd.c             |   25 +++++
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |   12 ++-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c  |   12 ++-
 drivers/net/wireless/orinoco.c             |   30 +++---
 drivers/net/wireless/p54/p54common.c       |   12 ++-
 drivers/net/wireless/p54/p54usb.c          |  149 +++++++++++++++++-----------
 drivers/net/wireless/p54/p54usb.h          |    1 +
 drivers/pci/msi.c                          |   16 ++--
 drivers/serial/jsm/jsm_tty.c               |    6 +
 drivers/video/aty/mach64_ct.c              |   11 ++
 drivers/xen/balloon.c                      |   33 ++++++-
 fs/cifs/connect.c                          |   18 ++--
 fs/dlm/plock.c                             |    2 +
 fs/nfsd/nfs4state.c                        |   31 ++++--
 include/linux/pci_ids.h                    |    1 +
 include/linux/slab_def.h                   |   10 +--
 mm/mlock.c                                 |   47 +---------
 net/mac80211/rc80211_minstrel.c            |   10 +-
 net/netfilter/nf_conntrack_netlink.c       |    3 +
 33 files changed, 347 insertions(+), 218 deletions(-)
