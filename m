Return-Path: <linux-kernel-owner+w=401wt.eu-S933083Ab0AFXrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083Ab0AFXrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 18:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932976Ab0AFXri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 18:47:38 -0500
Received: from kroah.org ([198.145.64.141]:34529 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932908Ab0AFXrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 18:47:37 -0500
Date: Wed, 6 Jan 2010 15:43:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.27.43
Message-ID: <20100106234332.GA1960@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.27.43 kernel.  All users of the
2.6.27 kernel series are very strongly encouraged to upgrade.

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                       |    2 +-
 arch/x86/kernel/ptrace.c                       |   16 ++++++++--------
 arch/x86/kvm/mmu.c                             |    8 ++++++++
 drivers/ata/pata_cmd64x.c                      |    2 +-
 drivers/i2c/chips/tsl2550.c                    |    3 +++
 drivers/net/wireless/libertas/wext.c           |    2 --
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
 17 files changed, 68 insertions(+), 27 deletions(-)

Bartlomiej Zolnierkiewicz (1):
      pata_cmd64x: fix overclocking of UDMA0-2 modes

Clemens Ladisch (1):
      sound: sgio2audio/pdaudiocf/usb-audio: initialize PCM buffer

Daniel Mack (1):
      Libertas: fix buffer overflow in lbs_get_essid()

Greg Kroah-Hartman (2):
      Revert: KVM: MMU: do not free active mmu pages in free_mmu_pages()
      Linux 2.6.27.43

Linus Torvalds (1):
      x86/ptrace: make genregs[32]_get/set more robust

Michele Jr De Candia (1):
      i2c/tsl2550: Fix lux value in extended mode

Patrick McHardy (1):
      ipv6: reassembly: use seperate reassembly queues for conntrack and local delivery

Serge E. Hallyn (1):
      generic_permission: MAY_OPEN is not write access

Stefan Weinhuber (1):
      S390: dasd: support DIAG access for read-only devices

