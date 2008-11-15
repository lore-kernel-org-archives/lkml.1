Return-Path: <linux-kernel-owner+w=401wt.eu-S1753346AbYKOFZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbYKOFZA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 00:25:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751182AbYKOFYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 00:24:47 -0500
Received: from kroah.org ([198.145.64.141]:50391 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750839AbYKOFYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 00:24:46 -0500
Date: Fri, 14 Nov 2008 21:22:20 -0800
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
Subject: [patch 00/22] 2.6.27.7-stable review
Message-ID: <20081115052220.GA3710@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.27.7 release.
There are 22 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Monday, Nov 17, 2008, 06:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.7-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h

 Makefile                                  |    2 +-
 arch/arm/mm/cache-feroceon-l2.c           |    4 +-
 arch/powerpc/include/asm/mpic.h           |    2 +
 arch/powerpc/platforms/85xx/mpc85xx_ds.c  |    3 +-
 arch/powerpc/platforms/86xx/pic.c         |    3 +-
 arch/powerpc/sysdev/mpic.c                |   59 +++++++++++++++++++++++--
 block/blk-merge.c                         |   19 +++++++-
 drivers/acpi/ec.c                         |   13 ++++-
 drivers/acpi/system.c                     |   25 +++++++---
 drivers/char/ipmi/ipmi_msghandler.c       |   20 +++++----
 drivers/char/ipmi/ipmi_si_intf.c          |   16 ++++---
 drivers/hwmon/ibmaem.c                    |   18 ++++---
 drivers/input/mouse/alps.c                |    1 +
 drivers/misc/sony-laptop.c                |    6 ++-
 drivers/net/Kconfig                       |    1 +
 drivers/net/bnx2x_init.h                  |    9 ++--
 drivers/net/bnx2x_main.c                  |    6 ++-
 drivers/net/wireless/ath5k/base.c         |   67 +++++++++++++++--------------
 drivers/net/wireless/ath5k/base.h         |    3 +-
 drivers/net/wireless/ath5k/hw.c           |   22 +++------
 drivers/net/wireless/ath5k/initvals.c     |    2 +
 drivers/net/wireless/hostap/hostap_wlan.h |    5 ++-
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    6 ++-
 drivers/net/wireless/rtl8187_dev.c        |    3 +
 fs/namespace.c                            |    7 +++-
 include/linux/bio.h                       |    7 +++
 mm/hugetlb.c                              |    5 +-
 mm/page_isolation.c                       |    5 +-
 scripts/package/builddeb                  |   24 +++++++++-
 29 files changed, 251 insertions(+), 112 deletions(-)
