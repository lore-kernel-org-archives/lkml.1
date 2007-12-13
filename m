Return-Path: <linux-kernel-owner+w=401wt.eu-S1762558AbXLMGvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762558AbXLMGvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 01:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761488AbXLMGnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:43:46 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53689 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761482AbXLMGnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:43:45 -0500
Date: Wed, 12 Dec 2007 22:42:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 00/36] 2.6.22-stable review
Message-ID: <20071213064250.GA29339@kroah.com>
References: <20071213063308.GA25301@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213063308.GA25301@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 10:33:08PM -0800, Greg KH wrote:
> This is the start of the stable review cycle for the 2.6.22.15 release.
> There are 36 patches in this series, all will be posted as a response to
> this one.  If anyone has any issues with these being applied, please let
> us know.  If anyone is a maintainer of the proper subsystem, and wants
> to add a Signed-off-by: line to the patch, please respond with it.

The rolled-up patch can be found at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.22.15-rc1.gz

the full diffstat can be found below for those interested.

thanks,

greg k-h

---------------

 Makefile                              |    2 -
 crypto/algapi.c                       |    6 +--
 drivers/ata/ahci.c                    |   65 ----------------------------------
 drivers/ata/libata-core.c             |   10 -----
 drivers/atm/he.c                      |   10 ++---
 drivers/block/rd.c                    |   13 ++++++
 drivers/isdn/i4l/isdn_common.c        |    5 ++
 drivers/isdn/i4l/isdn_net.c           |    8 ++--
 drivers/net/atl1/atl1_main.c          |   25 ++++++-------
 drivers/net/forcedeth.c               |   38 +++++++++++++------
 drivers/usb/host/ehci-hcd.c           |    5 ++
 drivers/usb/image/microtek.c          |    2 -
 drivers/video/fb_ddc.c                |    8 ++--
 fs/nfsd/nfsfh.c                       |   20 +++++++---
 fs/xfs/linux-2.6/xfs_buf.c            |    2 +
 include/linux/pci_ids.h               |    4 ++
 include/linux/thread_info.h           |   17 +++++++-
 include/net/tcp.h                     |    3 +
 kernel/exit.c                         |    2 -
 kernel/futex.c                        |   25 ++++++-------
 kernel/hrtimer.c                      |    8 ++++
 kernel/sys.c                          |    2 -
 lib/libcrc32c.c                       |    7 +--
 lib/textsearch.c                      |    8 +++-
 mm/shmem.c                            |    5 +-
 net/bridge/br.c                       |    4 +-
 net/bridge/br_input.c                 |    7 ++-
 net/bridge/netfilter/ebtable_broute.c |    4 +-
 net/decnet/dn_dev.c                   |    4 +-
 net/ipv4/arp.c                        |   19 ---------
 net/ipv4/netfilter/nf_nat_core.c      |    2 -
 net/ipv4/route.c                      |    8 +---
 net/ipv4/sysctl_net_ipv4.c            |    2 -
 net/ipv4/tcp_illinois.c               |    2 -
 net/ipv4/tcp_output.c                 |    1 
 net/ipv6/addrconf.c                   |   11 +++++
 net/key/af_key.c                      |    2 -
 net/netfilter/xt_TCPMSS.c             |    4 --
 net/rxrpc/Kconfig                     |    1 
 net/unix/af_unix.c                    |    9 ++++
 net/xfrm/xfrm_state.c                 |    2 -
 41 files changed, 190 insertions(+), 192 deletions(-)
