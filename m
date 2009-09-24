Return-Path: <linux-kernel-owner+w=401wt.eu-S1753002AbZIXRkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002AbZIXRkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 13:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbZIXRkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 13:40:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51688 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbZIXRkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 13:40:21 -0400
Date: Thu, 24 Sep 2009 10:37:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.27.35
Message-ID: <20090924173758.GA17077@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.27.35 kernel.  All users of the
2.6.27 kernel series are very strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.27.34 and 2.6.27.35

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                  |    2 
 arch/powerpc/include/asm/mmu-hash64.h     |    2 
 arch/powerpc/kernel/lparcfg.c             |    3 +
 arch/powerpc/kernel/rtas.c                |    7 ++-
 arch/powerpc/mm/slb.c                     |   16 +++++--
 arch/powerpc/platforms/pseries/reconfig.c |    9 +++-
 drivers/ata/libata-core.c                 |    8 +++
 drivers/char/tpm/tpm_tis.c                |   12 ++---
 drivers/ps3/ps3stor_lib.c                 |   65 ++++++++++++++++++++++++++++--
 fs/binfmt_elf.c                           |   28 ++++++------
 fs/nfsd/nfs3proc.c                        |    5 +-
 fs/nfsd/nfs4proc.c                        |    7 ++-
 fs/nfsd/nfsproc.c                         |    3 -
 fs/nfsd/vfs.c                             |   11 ++---
 fs/udf/lowlevel.c                         |    7 ++-
 include/linux/nfsd/nfsd.h                 |    2 
 sound/pci/cs46xx/cs46xx_lib.h             |    2 
 sound/pci/oxygen/oxygen_io.c              |   11 -----
 18 files changed, 146 insertions(+), 54 deletions(-)

Brian King (1):
      powerpc/pseries: Fix to handle slb resize across migration

Clemens Ladisch (1):
      sound: oxygen: work around MCE when changing volume

David Shaw (1):
      Short write in nfsd becomes a full write to the client

Geoff Levand (1):
      powerpc/ps3: Workaround for flash memory I/O error

Greg Kroah-Hartman (1):
      Linux 2.6.27.35

Jan Kara (1):
      udf: Use device size when drive reported bogus number of written blocks

Jason Gunthorpe (1):
      TPM: Fixup boot probe timeout for tpm_tis driver

Roland McGrath (1):
      binfmt_elf: fix PT_INTERP bss handling

Sophie Hamilton (1):
      ALSA: cs46xx - Fix minimum period size

Tejun Heo (1):
      libata: fix off-by-one error in ata_tf_read_block()

Wei Yongjun (1):
      nfsd: fix hung up of nfs client while sync write data to nfs server

