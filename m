Return-Path: <linux-kernel-owner+w=401wt.eu-S1755948AbXKSSbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbXKSSbM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 13:31:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbXKSSXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 13:23:24 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49488 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbXKSSXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 13:23:23 -0500
Date: Mon, 19 Nov 2007 10:22:37 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/26] 2.6.22-stable review
Message-ID: <20071119182237.GA15620@kroah.com>
References: <20071119181746.GA15425@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119181746.GA15425@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 10:17:46AM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 2.6.22.14 release.
> There are 26 patches in this series, all will be posted as a response to
> this one.  If anyone has any issues with these being applied, please let
> us know.  If anyone is a maintainer of the proper subsystem, and wants
> to add a Signed-off-by: line to the patch, please respond with it.

Full patch can be found at:
	kernel.org/pub/linux/kernel/v2.6/stable-review-patch-2.6.22.14-rc1.gz

and the diffstat is below.

thanks,

greg k-h

------------

 Makefile                               |    2 
 arch/i386/kernel/tsc.c                 |    5 
 drivers/i2c/busses/i2c-pasemi.c        |    5 
 drivers/i2c/chips/eeprom.c             |   37 ++++---
 drivers/ide/pci/serverworks.c          |    1 
 drivers/isdn/hardware/avm/b1.c         |   28 ++---
 drivers/isdn/hardware/avm/c4.c         |   14 ++
 drivers/net/forcedeth.c                |   19 ++-
 drivers/scsi/hptiop.c                  |    5 
 drivers/usb/core/hcd.h                 |    8 +
 drivers/usb/core/hub.c                 |   15 ++
 drivers/usb/host/ehci-hcd.c            |    8 +
 drivers/usb/serial/generic.c           |    7 -
 drivers/usb/serial/kobil_sct.c         |  170 +++++++++++++--------------------
 fs/ocfs2/aops.c                        |   24 ++++
 include/linux/netlink.h                |    2 
 ipc/mqueue.c                           |    6 -
 kernel/futex_compat.c                  |   24 +++-
 kernel/params.c                        |   15 +-
 kernel/softlockup.c                    |    7 -
 mm/page-writeback.c                    |    4 
 mm/slub.c                              |   22 ----
 net/ipv4/ipcomp.c                      |    3 
 net/ipv6/ipcomp6.c                     |    3 
 net/netfilter/nf_conntrack_proto_tcp.c |   38 +++----
 net/netlink/af_netlink.c               |   10 -
 net/sched/cls_u32.c                    |    4 
 net/sched/sch_teql.c                   |    3 
 net/socket.c                           |    5 
 sound/pci/hda/patch_sigmatel.c         |   14 +-
 sound/pci/rme9652/hdsp.c               |    3 
 31 files changed, 280 insertions(+), 231 deletions(-)
