Return-Path: <linux-kernel-owner+w=401wt.eu-S1761414AbYBZBGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761414AbYBZBGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 20:06:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbYBZBF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 20:05:59 -0500
Received: from ns1.suse.de ([195.135.220.2]:47896 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbYBZBF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 20:05:58 -0500
Date: Mon, 25 Feb 2008 17:05:49 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.22.19
Message-ID: <20080226010549.GD26912@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.22.19
kernel.

It fixes a number of different bugs and all users of the 2.6.22 series
are encouraged to upgrade.  It fixes two CVE entries, CVE-2007-3731 and
CVE-2007-3731.

This should be the last release of the .22 kernel series, all users are
encouraged to move to the .24 kernel series at this time.

I'll also be replying to this message with a copy of the patch between
2.6.22.18 and 2.6.22.19

The updated 2.6.22.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.22.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.22.y.git;a=summary

thanks,

greg k-h

--------
 Makefile                                        |    2 
 arch/i386/kernel/entry.S                        |    2 
 arch/i386/kernel/ptrace.c                       |   22 +++--
 arch/i386/kernel/traps.c                        |   10 +-
 arch/x86_64/kernel/ptrace.c                     |   23 ++++--
 drivers/ata/sata_promise.c                      |   91 ++++++++++++++++++++++--
 drivers/block/cciss.c                           |    5 +
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
 27 files changed, 305 insertions(+), 115 deletions(-)

Summary of changes from v2.6.22.18 to v2.6.22.19
================================================

Christoph Lameter (2):
      quicklists: do not release off node pages early
      quicklists: Only consider memory that can be used with GFP_KERNEL

Greg Kroah-Hartman (1):
      Linux 2.6.22.19

Ian Abbott (1):
      PCI: Fix fakephp deadlock

J. Bruce Fields (2):
      knfsd: fix spurious EINVAL errors on first access of new filesystem
      knfsd: query filesystem for NFSv4 getattr of FATTR4_MAXNAME

James Bottomley (1):
      SCSI: sd: handle bad lba in sense information

Jesper Juhl (1):
      cciss: fix memory leak

Jonathan Corbet (1):
      Be more robust about bad arguments in get_user_pages()

Jozsef Kadlecsik (1):
      NETFILTER: nf_conntrack_tcp: conntrack reopening fix

Kees Cook (1):
      pci: fix unterminated pci_device_id lists

Mattia Dongili (1):
      sony-laptop: call sonypi_compat_init earlier

Mikael Pettersson (2):
      sata_promise: FastTrack TX4200 is a second-generation chip
      sata_promise: ASIC PRD table bug workaround

Peter Zijlstra (1):
      i386: fixup TRACE_IRQ breakage (CVE-2007-3731)

Roland McGrath (1):
      Handle bogus %cs selector in single-step instruction decoding (CVE-2007-3731)

Stephen Hemminger (2):
      VIA_VELOCITY: Don't oops on MTU change.
      via-velocity: don't oops on MTU change (resend)

Trond Myklebust (4):
      NFS: Fix a potential file corruption issue when writing
      NFS: Fix nfs_reval_fsid()
      NFSv2/v3: Fix a memory leak when using -onolock
      NFS: Fix an Oops in encode_lookup()

Wang Zhenyu (1):
      Intel_agp: really fix 945/965GME

