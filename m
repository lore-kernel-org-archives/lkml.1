Return-Path: <linux-kernel-owner+w=401wt.eu-S1752869AbZG1Xk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbZG1Xk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbZG1Xk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:40:26 -0400
Received: from kroah.org ([198.145.64.141]:53143 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151AbZG1Xk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:40:26 -0400
Date: Tue, 28 Jul 2009 16:39:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/37] 2.6.27.29-stable review
Message-ID: <20090728233936.GA7846@kroah.com>
References: <20090728230145.GA10486@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090728230145.GA10486@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 04:01:45PM -0700, Greg KH wrote:
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.29-rc1.gz
> and the diffstat can be found below.

Oops, forgot the diffstat, here it is.

 Makefile                              |    2 +-
 arch/x86/mm/gup.c                     |    9 ++-
 arch/x86/mm/srat_64.c                 |    6 +-
 drivers/acpi/ec.c                     |    3 +-
 drivers/hid/usbhid/hiddev.c           |    4 +-
 drivers/hwmon/max6650.c               |    1 +
 drivers/input/misc/wistron_btns.c     |    9 +++
 drivers/isdn/gigaset/ev-layer.c       |   44 +++++++--------
 drivers/md/md.c                       |    6 +-
 drivers/net/e100.c                    |    3 +
 drivers/net/hamradio/6pack.c          |   10 ++-
 drivers/net/hamradio/mkiss.c          |   41 ++++++++------
 drivers/net/ppp_async.c               |   11 ++-
 drivers/net/ppp_synctty.c             |   11 ++-
 drivers/net/r8169.c                   |  102 ++++++++++++++++++--------------
 drivers/net/sky2.c                    |    2 +-
 drivers/net/usb/cdc_subset.c          |    7 +-
 drivers/net/usb/pegasus.c             |   29 ++++++----
 drivers/net/wireless/strip.c          |   39 ++++++++-----
 drivers/pnp/pnpacpi/core.c            |   21 +++++--
 drivers/scsi/zalon.c                  |    2 +-
 drivers/usb/core/devio.c              |   57 ++++++++++---------
 drivers/usb/gadget/ether.c            |   11 ++--
 drivers/usb/host/ehci-sched.c         |   12 +++-
 drivers/usb/serial/ti_usb_3410_5052.c |    3 +-
 fs/binfmt_elf.c                       |    4 +-
 fs/ecryptfs/keystore.c                |   13 ++++
 include/net/x25.h                     |    2 +-
 mm/filemap.c                          |    1 +
 mm/slab.c                             |    2 +-
 mm/slob.c                             |    2 +
 mm/slub.c                             |    2 +
 net/sunrpc/clnt.c                     |   26 ++++++---
 net/sunrpc/xprtsock.c                 |   23 +++++---
 net/x25/af_x25.c                      |   23 ++++++--
 net/x25/x25_timer.c                   |    2 +-
 net/xfrm/xfrm_algo.c                  |    4 +-
 sound/pci/ca0106/ca0106_main.c        |    4 +-
 sound/pci/hda/patch_realtek.c         |   33 +++++------
 sound/pci/oxygen/virtuoso.c           |    2 +
 sound/usb/usbaudio.c                  |   14 ++++-
 41 files changed, 370 insertions(+), 232 deletions(-)
