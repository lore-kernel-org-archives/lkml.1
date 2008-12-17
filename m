Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759495AbYLQAFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495AbYLQAFA (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 19:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbYLQAEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 19:04:49 -0500
Received: from kroah.org ([198.145.64.141]:50967 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753164AbYLQAEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 19:04:48 -0500
Date: Tue, 16 Dec 2008 16:03:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
        Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
        Chris Wedgwood <reviews@ml.cw.f00f.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Chuck Ebbert <cebbert@redhat.com>,
        Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
        Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
        Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [patch 00/22] 2.6.27.10 stable review
Message-ID: <20081217000306.GA4504@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.27.10 release.
There are 22 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Thursday, December 18, 22:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.10-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h


 Documentation/kernel-parameters.txt     |    2 
 Makefile                                |    2 
 arch/x86/kernel/amd_iommu_init.c        |    2 
 arch/x86/kernel/setup.c                 |   12 ++---
 arch/x86/kernel/smpboot.c               |    2 
 arch/x86/kernel/vmi_32.c                |   16 ++++--
 drivers/ata/libata-core.c               |   65 +++++++++++++++++++++++++---
 drivers/char/cp437.uni                  |   12 ++---
 drivers/char/vt.c                       |    2 
 drivers/firewire/fw-ohci.c              |   11 +++-
 drivers/firewire/fw-transaction.c       |    3 +
 drivers/firewire/fw-transaction.h       |    2 
 drivers/ieee1394/nodemgr.c              |    6 ++
 drivers/isdn/hardware/avm/b1isa.c       |    6 --
 drivers/media/video/tvaudio.c           |   30 +++++++++++-
 drivers/net/bonding/bond_main.c         |    3 +
 drivers/net/e1000e/ich8lan.c            |    9 +++
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    6 +-
 drivers/net/wireless/iwlwifi/iwl-core.c |    3 +
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    3 -
 drivers/net/wireless/iwlwifi/iwl-rx.c   |   26 +++++++----
 drivers/net/wireless/iwlwifi/iwl-sta.c  |   24 +++++++++-
 drivers/video/macfb.c                   |   74 +++++++++++++++-----------------
 include/asm-x86/vmi.h                   |    8 +++
 include/linux/can/core.h                |    2 
 kernel/sched_clock.c                    |    6 +-
 lib/idr.c                               |    8 +++
 mm/page_alloc.c                         |    4 -
 net/can/af_can.c                        |   68 ++++++++++++++++++++++-------
 net/can/bcm.c                           |    7 +--
 net/core/dev.c                          |    2 
 net/key/af_key.c                        |    1 
 net/sunrpc/auth_generic.c               |   20 +++++++-
 33 files changed, 318 insertions(+), 129 deletions(-)
