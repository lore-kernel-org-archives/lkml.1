Return-Path: <linux-kernel-owner+w=401wt.eu-S1759457AbYJVWTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759457AbYJVWTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 18:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYJVWS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 18:18:57 -0400
Received: from kroah.org ([198.145.64.141]:54881 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753276AbYJVWS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 18:18:56 -0400
Date: Wed, 22 Oct 2008 15:10:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.27.3
Message-ID: <20081022221007.GA15277@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.27.3
kernel.

It contains a wide range of bugfixes, and all users of the 2.6.27 kernel
series are strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.27.2 and 2.6.27.3

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/video4linux/CARDLIST.au0828 |    2 
 Makefile                                  |    4 -
 drivers/base/core.c                       |   25 ++++++--
 drivers/gpu/drm/i915/i915_dma.c           |    2 
 drivers/md/md.c                           |    6 --
 drivers/media/dvb/siano/sms-cards.c       |    4 +
 drivers/media/video/au0828/au0828-cards.c |    3 +
 drivers/media/video/tvaudio.c             |    2 
 drivers/net/wireless/ath9k/core.h         |    2 
 drivers/net/wireless/ath9k/main.c         |    8 ++
 drivers/usb/core/hcd.c                    |    4 +
 drivers/usb/core/hcd.h                    |    6 ++
 drivers/usb/gadget/s3c2410_udc.c          |    2 
 drivers/usb/gadget/u_ether.c              |    7 ++
 drivers/usb/host/ehci-hcd.c               |   15 ++++-
 drivers/usb/host/ohci-hcd.c               |    3 +
 drivers/usb/host/ohci-hub.c               |   87 +++++++++++++++++-------------
 drivers/usb/host/uhci-hcd.c               |    3 +
 drivers/usb/musb/Kconfig                  |    4 -
 drivers/usb/musb/cppi_dma.h               |    4 -
 drivers/usb/musb/davinci.c                |   20 +-----
 drivers/usb/musb/musb_core.c              |    8 +-
 drivers/usb/musb/musb_host.c              |    6 +-
 drivers/video/console/fbcon.c             |    4 -
 fs/xfs/linux-2.6/xfs_super.c              |    2 
 kernel/module.c                           |    2 
 net/mac80211/wext.c                       |    2 
 27 files changed, 148 insertions(+), 89 deletions(-)

Alan Stern (3):
      OHCI: Allow broken controllers to auto-stop
      USB: OHCI: fix endless polling behavior
      USB: EHCI: log a warning if ehci-hcd is not loaded first

Alexey Dobriyan (1):
      modules: fix module "notes" kobject leak

Arjan van de Ven (1):
      security: avoid calling a NULL function pointer in drivers/video/tvaudio.c

Chris Webb (1):
      md: Fix rdev_size_store with size == 0

Christoph Hellwig (1):
      xfs: fix remount rw with unrecognized options

Cornelia Huck (2):
      Driver core: Fix cleanup in device_create_vargs().
      Driver core: Clarify device cleanup.

David Brownell (2):
      usb gadget: cdc ethernet notification bugfix
      usb: musb_hdrc build fixes

Greg Kroah-Hartman (1):
      Linux 2.6.27.3

Johannes Berg (1):
      ath9k/mac80211: disallow fragmentation in ath9k, report to userspace

Luis R. Rodriguez (1):
      ath9k: fix oops on trying to hold the wrong spinlock

Matthias Hopf (1):
      drm/i915: fix ioremap of a user address for non-root (CVE-2008-3831)

Michael Krufky (2):
      DVB: au0828: add support for another USB id for Hauppauge HVR950Q
      DVB: sms1xxx: support two new revisions of the Hauppauge WinTV MiniStick

Oleg Nesterov (1):
      fbcon_set_all_vcs: fix kernel crash when switching the rotated consoles

Yauhen Kharuzhy (1):
      USB: Fix s3c2410_udc usb speed handling

