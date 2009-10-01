Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbZJAXn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbZJAXn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 19:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbZJAXn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 19:43:58 -0400
Received: from kroah.org ([198.145.64.141]:42020 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754824AbZJAXiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 19:38:06 -0400
Date: Thu, 1 Oct 2009 16:35:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 00/30] 2.6.30.9-stable review
Message-ID: <20091001233504.GA17709@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NOTE:  This is going to be the last .30 kernel release unless something
odd happens.  Everyone should move to the .31 kernel release soon.

This is the start of the stable review cycle for the 2.6.30.9 release.
There are 30 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Saturday, October 3, 2009 23:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.30.9-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h

------

 Makefile                                  |    2 +-
 arch/powerpc/include/asm/pte-common.h     |    2 +-
 arch/powerpc/mm/pgtable.c                 |   19 +++++-
 arch/x86/include/asm/kvm_host.h           |    1 +
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   15 +++--
 arch/x86/kernel/kvmclock.c                |    4 +-
 arch/x86/kvm/lapic.c                      |    9 +++
 arch/x86/kvm/mmu.c                        |    9 +--
 arch/x86/kvm/vmx.c                        |   11 ++--
 arch/x86/kvm/x86.c                        |   31 ++++++++--
 drivers/acpi/pci_slot.c                   |    4 +-
 drivers/ata/ahci.c                        |    4 +-
 drivers/net/wireless/p54/p54usb.c         |    1 +
 drivers/pcmcia/at91_cf.c                  |    2 +-
 drivers/pcmcia/au1000_generic.c           |    2 +-
 drivers/pcmcia/bfin_cf_pcmcia.c           |    2 +-
 drivers/pcmcia/cs.c                       |    2 +-
 drivers/pcmcia/i82092.c                   |    2 +-
 drivers/pcmcia/i82365.c                   |    2 +-
 drivers/pcmcia/m32r_cfc.c                 |    2 +-
 drivers/pcmcia/m32r_pcc.c                 |    2 +-
 drivers/pcmcia/m8xx_pcmcia.c              |    2 +-
 drivers/pcmcia/omap_cf.c                  |    2 +-
 drivers/pcmcia/pd6729.c                   |    2 +-
 drivers/pcmcia/pxa2xx_base.c              |    2 +-
 drivers/pcmcia/sa1100_generic.c           |    2 +-
 drivers/pcmcia/sa1111_generic.c           |    2 +-
 drivers/pcmcia/tcic.c                     |    2 +-
 drivers/pcmcia/vrc4171_card.c             |    2 +-
 drivers/pcmcia/yenta_socket.c             |   88 ++++++++++++++++-------------
 fs/cifs/cifsglob.h                        |    4 +-
 fs/inode.c                                |   14 +++--
 fs/nilfs2/btnode.c                        |    1 +
 fs/proc/kcore.c                           |    8 ++-
 fs/proc/uptime.c                          |    7 ++-
 include/linux/kvm_para.h                  |    1 +
 include/pcmcia/ss.h                       |    2 +-
 mm/hugetlb.c                              |    2 +-
 net/ax25/af_ax25.c                        |    2 +-
 net/bridge/br_netfilter.c                 |    2 +-
 net/bridge/netfilter/ebt_ulog.c           |    2 +-
 net/ipv4/netfilter/nf_nat_core.c          |    2 +-
 net/packet/af_packet.c                    |    4 +-
 scripts/kallsyms.c                        |    2 +-
 44 files changed, 172 insertions(+), 113 deletions(-)
