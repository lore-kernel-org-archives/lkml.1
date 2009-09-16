Return-Path: <linux-kernel-owner+w=401wt.eu-S1755208AbZIPWSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbZIPWSL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801AbZIPWSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:18:09 -0400
Received: from kroah.org ([198.145.64.141]:49769 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbZIPWSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:18:08 -0400
Date: Wed, 16 Sep 2009 15:15:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 00/10] 2.6.27.35-stable review
Message-ID: <20090916221529.GA28162@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.27.35 release.
There are 10 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Friday, September 18, 22:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.35-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h

----------

 Makefile                                  |    2 +-
 arch/powerpc/include/asm/mmu-hash64.h     |    2 +
 arch/powerpc/kernel/lparcfg.c             |    3 +
 arch/powerpc/kernel/rtas.c                |    7 +++-
 arch/powerpc/mm/slb.c                     |   16 +++++--
 arch/powerpc/platforms/pseries/reconfig.c |    9 ++++-
 drivers/ata/libata-core.c                 |    8 +++-
 drivers/char/tpm/tpm_tis.c                |   12 +++---
 drivers/ps3/ps3stor_lib.c                 |   65 +++++++++++++++++++++++++++-
 fs/binfmt_elf.c                           |   28 ++++++------
 fs/nfsd/nfs3proc.c                        |    5 +-
 fs/nfsd/nfs4proc.c                        |    7 ++-
 fs/nfsd/nfsproc.c                         |    3 +-
 fs/nfsd/vfs.c                             |   11 +++--
 fs/udf/lowlevel.c                         |    7 +++-
 include/linux/nfsd/nfsd.h                 |    2 +-
 sound/pci/cs46xx/cs46xx_lib.h             |    2 +-
 sound/pci/oxygen/oxygen_io.c              |   11 +----
 18 files changed, 146 insertions(+), 54 deletions(-)
