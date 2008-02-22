Return-Path: <linux-kernel-owner+w=401wt.eu-S1758779AbYBVVml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779AbYBVVml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 16:42:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758931AbYBVVm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 16:42:29 -0500
Received: from cantor.suse.de ([195.135.220.2]:46064 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757164AbYBVVm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 16:42:27 -0500
Date: Fri, 22 Feb 2008 13:39:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 00/23] 2.6.22-stable review
Message-ID: <20080222213927.GA8686@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.22.19 release.
There are 23 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the
Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
to add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Monday, Feb 24, 2008, 22:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.22.19-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-----------
 Makefile                                        |    2 
 arch/i386/kernel/entry.S                        |    2 
 arch/i386/kernel/ptrace.c                       |   22 +++--
 arch/i386/kernel/traps.c                        |   10 +-
 arch/x86_64/kernel/ptrace.c                     |   23 ++++--
 drivers/ata/sata_promise.c                      |   91 ++++++++++++++++++++++--
 drivers/block/cciss.c                           |    6 +
 drivers/char/agp/intel-agp.c                    |   17 +++-
 drivers/char/ipmi/ipmi_si_intf.c                |    3 
 drivers/media/video/usbvision/usbvision-cards.c |    1 
 drivers/misc/sony-laptop.c                      |   15 ++-
 drivers/mtd/nand/cafe_nand.c                    |    3 
 drivers/net/via-velocity.c                      |   16 ++--
 drivers/pci/hotplug/fakephp.c                   |   39 +++++++++-
 drivers/scsi/sd.c                               |   34 ++++----
 fs/nfs/client.c                                 |   35 +++++----
 fs/nfs/dir.c                                    |   11 +-
 fs/nfs/getroot.c                                |    3 
 fs/nfs/inode.c                                  |    4 -
 fs/nfs/write.c                                  |   20 ++++-
 fs/nfsd/nfs2acl.c                               |    2 
 fs/nfsd/nfs3acl.c                               |    2 
 fs/nfsd/nfs4xdr.c                               |    5 -
 include/linux/quicklist.h                       |    8 --
 mm/memory.c                                     |    2 
 mm/quicklist.c                                  |   12 ++-
 net/netfilter/nf_conntrack_proto_tcp.c          |   33 ++++++--
 27 files changed, 306 insertions(+), 115 deletions(-)
