Return-Path: <linux-kernel-owner+w=401wt.eu-S1757748AbZAMB3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757748AbZAMB3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 20:29:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757059AbZAMB2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 20:28:54 -0500
Received: from kroah.org ([198.145.64.141]:35851 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755699AbZAMB2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 20:28:52 -0500
Date: Mon, 12 Jan 2009 17:26:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: [patch 00/21] 2.6.27-stable review
Message-ID: <20090113012633.GA4512@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.27.11 release.

It basically flushes out all of the 2.6.27 patches that went into the
2.6.28 release.  Almost none of the patches marked for the stable series
that have gone in after 2.6.28 came out has gone into this tree yet.
That will come in the next releases, this is just to get these older
fixes out to those who need them now.

There are 21 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Thursday, January 15, 2009, 00:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.11-rc1.gz
and the diffstat can be found below.


thanks,
greg k-h

------------

 Makefile                              |    2 +-
 arch/powerpc/lib/rheap.c              |    1 +
 arch/x86/kernel/amd_iommu.c           |    4 ++--
 arch/x86/kernel/amd_iommu_init.c      |    7 ++++++-
 crypto/async_tx/async_xor.c           |   11 +++++++++--
 drivers/block/cciss.c                 |    5 +++++
 drivers/dma/dmaengine.c               |    3 +++
 drivers/dma/ioat_dma.c                |    5 ++++-
 drivers/dma/iop-adma.c                |   16 +++++++++++++---
 drivers/dma/mv_xor.c                  |   15 ++++++++++++---
 drivers/md/bitmap.c                   |   22 +++++++++++++++++-----
 drivers/net/starfire.c                |    5 +++++
 drivers/net/wireless/iwlwifi/iwl-tx.c |    7 +++----
 drivers/scsi/aacraid/linit.c          |    4 ++--
 drivers/scsi/ibmvscsi/ibmvstgt.c      |   16 +++++++++-------
 drivers/usb/gadget/f_rndis.c          |    4 ++++
 drivers/usb/storage/unusual_devs.h    |   16 +++++++++++++++-
 include/asm-parisc/tlbflush.h         |    5 ++++-
 sound/pci/hda/patch_sigmatel.c        |    1 +
 sound/soc/omap/omap-pcm.c             |    2 +-
 20 files changed, 117 insertions(+), 34 deletions(-)
