Return-Path: <linux-kernel-owner+w=401wt.eu-S1761006AbZEFUi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761006AbZEFUi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 16:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759516AbZEFUiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 16:38:17 -0400
Received: from kroah.org ([198.145.64.141]:33756 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756958AbZEFUiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 16:38:16 -0400
Date: Wed, 6 May 2009 13:33:53 -0700
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
Subject: [patch 00/18] 2.6.27.23-stable review
Message-ID: <20090506203353.GA14624@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the start of the stable review cycle for the 2.6.27.23 release.
There are 18 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Friday, May 8, 20:00:00 UTC.  Anything
received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.23-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h

 Makefile                            |    2 +-
 arch/mips/Kconfig                   |    1 +
 arch/mips/kernel/linux32.c          |   69 ++++++++++++++-----------
 arch/mips/kernel/scall32-o32.S      |    4 +-
 arch/mips/kernel/scall64-64.S       |    2 +-
 arch/mips/kernel/scall64-n32.S      |   28 +++++-----
 arch/mips/kernel/scall64-o32.S      |   40 +++++++-------
 arch/mips/kernel/signal.c           |    5 +-
 arch/mips/kernel/signal32.c         |   28 +++++-----
 arch/mips/kernel/syscall.c          |   26 +++++-----
 arch/mips/mm/cache.c                |    5 +-
 arch/x86/pci/mmconfig-shared.c      |    6 +-
 drivers/acpi/resources/rscreate.c   |   27 +---------
 drivers/char/hw_random/virtio-rng.c |    4 +-
 drivers/gpu/drm/i915/i915_drv.h     |    6 ++-
 drivers/net/forcedeth.c             |    3 +
 drivers/net/mv643xx_eth.c           |    2 -
 drivers/net/wireless/b43/dma.c      |   50 ++++++++++++++----
 drivers/net/wireless/rndis_wlan.c   |   14 ++++--
 drivers/pci/quirks.c                |    1 +
 drivers/usb/serial/usb-serial.c     |   97 ++++++++++++++++++++++++-----------
 drivers/usb/storage/unusual_devs.h  |    6 ++
 fs/proc/array.c                     |   13 +++--
 fs/proc/base.c                      |    5 ++-
 fs/proc/task_mmu.c                  |    4 ++
 include/drm/drm_pciids.h            |    1 +
 kernel/time/tick-common.c           |   12 ++++-
 mm/madvise.c                        |    8 +++
 scripts/mod/modpost.c               |    1 +
 29 files changed, 287 insertions(+), 183 deletions(-)
