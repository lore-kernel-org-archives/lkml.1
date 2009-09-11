Return-Path: <linux-kernel-owner+w=401wt.eu-S1753281AbZIKA3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbZIKA3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 20:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbZIKA3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 20:29:08 -0400
Received: from kroah.org ([198.145.64.141]:38056 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbZIKA3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 20:29:01 -0400
Date: Thu, 10 Sep 2009 17:26:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 00/22] 2.6.30.7-stable review
Message-ID: <20090911002616.GA12087@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.30.7 release.
There are 22 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Sunday, September 12, 2009 00:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.30.7-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h

-----------

 Makefile                            |    2 +-
 arch/sparc/include/asm/pgtable_64.h |   12 ++++-
 arch/sparc/kernel/irq_64.c          |    2 +-
 arch/sparc/kernel/ktlb.S            |   42 +++++++++++++++--
 arch/sparc/kernel/nmi.c             |    2 +-
 arch/sparc/kernel/sys32.S           |    2 +-
 arch/sparc/mm/init_64.c             |   43 +++++++++--------
 arch/sparc/mm/init_64.h             |    7 ++-
 arch/sparc/prom/misc_64.c           |    2 +-
 arch/sparc/prom/printf.c            |    7 +--
 drivers/md/dm-exception-store.c     |   13 +++++
 drivers/md/dm-exception-store.h     |    4 ++
 drivers/md/dm-raid1.c               |    8 +++-
 drivers/md/dm-snap-persistent.c     |   88 +++++++++++++++++++++--------------
 drivers/net/e100.c                  |    2 +-
 drivers/net/ppp_generic.c           |   34 +++++++------
 drivers/net/pppol2tp.c              |    1 +
 drivers/pci/iov.c                   |   23 +++++++++
 drivers/pci/pci.h                   |   13 +++++
 drivers/pci/setup-bus.c             |    4 +-
 drivers/pci/setup-res.c             |    6 +-
 drivers/scsi/sd.c                   |   45 ++++++++---------
 fs/jffs2/wbuf.c                     |   10 ++++
 fs/nilfs2/btnode.c                  |    2 +-
 mm/slub.c                           |    4 +-
 net/core/net_namespace.c            |    2 +-
 net/dccp/proto.c                    |    1 +
 net/ipv4/ip_gre.c                   |    2 +-
 sound/pci/oxygen/oxygen_lib.c       |    3 +
 sound/pci/oxygen/oxygen_pcm.c       |    2 +
 30 files changed, 264 insertions(+), 124 deletions(-)
