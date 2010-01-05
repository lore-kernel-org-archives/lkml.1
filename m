Return-Path: <linux-kernel-owner+w=401wt.eu-S932230Ab0AETyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230Ab0AETyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 14:54:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932147Ab0AETxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 14:53:53 -0500
Received: from kroah.org ([198.145.64.141]:46033 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932158Ab0AETw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:52:58 -0500
Date: Tue, 5 Jan 2010 11:50:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org
Subject: [00/10] 2.6.27.43 stable review
Message-ID: <20100105195007.GA23952@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.27.43 release.
There are 10 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Thursday, Jan 7, 00:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
      kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.43-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Makefile                                       |    2 +-
 arch/x86/kernel/ptrace.c                       |   16 ++++++++--------
 arch/x86/kvm/mmu.c                             |    8 ++++++++
 drivers/ata/pata_cmd64x.c                      |    2 +-
 drivers/i2c/chips/tsl2550.c                    |    3 +++
 drivers/net/wireless/libertas/wext.c           |    2 --
 drivers/net/wireless/rt2x00/rt61pci.c          |    5 +++++
 drivers/s390/block/dasd_diag.c                 |   19 ++++++++++++++++---
 fs/namei.c                                     |    1 +
 include/net/ipv6.h                             |    7 +++++++
 include/net/netfilter/ipv6/nf_conntrack_ipv6.h |    2 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   13 +++++++++++--
 net/ipv6/netfilter/nf_conntrack_reasm.c        |    7 ++++---
 net/ipv6/reassembly.c                          |    5 ++++-
 sound/mips/sgio2audio.c                        |    2 +-
 sound/pcmcia/pdaudiocf/pdaudiocf_pcm.c         |    2 +-
 sound/usb/usbaudio.c                           |    2 +-
 virt/kvm/kvm_main.c                            |    2 --
 18 files changed, 73 insertions(+), 27 deletions(-)
