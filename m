Return-Path: <linux-kernel-owner+w=401wt.eu-S1753163AbZG3XNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbZG3XNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 19:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbZG3XNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 19:13:15 -0400
Received: from kroah.org ([198.145.64.141]:33208 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbZG3XNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 19:13:14 -0400
Date: Thu, 30 Jul 2009 16:11:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.27.29
Message-ID: <20090730231134.GA19869@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.27.29 kernel.  All users of the
2.6.27 kernel series are very strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.27.28 and 2.6.27.29

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                              |    2 
 arch/x86/mm/gup.c                     |    9 ++-
 arch/x86/mm/srat_64.c                 |    6 +-
 drivers/acpi/ec.c                     |    3 -
 drivers/hid/usbhid/hiddev.c           |    4 +
 drivers/hwmon/max6650.c               |    1 
 drivers/input/misc/wistron_btns.c     |    9 +++
 drivers/isdn/gigaset/ev-layer.c       |   44 ++++++--------
 drivers/md/md.c                       |    6 +-
 drivers/net/e100.c                    |    3 +
 drivers/net/hamradio/6pack.c          |   10 ++-
 drivers/net/hamradio/mkiss.c          |   41 ++++++++-----
 drivers/net/ppp_async.c               |   11 ++-
 drivers/net/ppp_synctty.c             |   11 ++-
 drivers/net/r8169.c                   |  102 +++++++++++++++++++---------------
 drivers/net/sky2.c                    |    2 
 drivers/net/usb/cdc_subset.c          |    7 +-
 drivers/net/usb/pegasus.c             |   29 +++++----
 drivers/net/wireless/strip.c          |   39 ++++++++-----
 drivers/pnp/pnpacpi/core.c            |   21 ++++---
 drivers/scsi/zalon.c                  |    2 
 drivers/usb/core/devio.c              |   57 ++++++++++---------
 drivers/usb/gadget/ether.c            |   11 ++-
 drivers/usb/host/ehci-sched.c         |   12 ++--
 drivers/usb/serial/ti_usb_3410_5052.c |    3 -
 fs/binfmt_elf.c                       |    4 -
 fs/ecryptfs/keystore.c                |   13 ++++
 include/net/x25.h                     |    2 
 mm/filemap.c                          |    1 
 mm/slab.c                             |    2 
 mm/slob.c                             |    2 
 mm/slub.c                             |    2 
 net/sunrpc/clnt.c                     |   26 ++++++--
 net/sunrpc/xprtsock.c                 |   23 +++++--
 net/x25/af_x25.c                      |   23 ++++++-
 net/x25/x25_timer.c                   |    2 
 net/xfrm/xfrm_algo.c                  |    4 -
 sound/pci/ca0106/ca0106_main.c        |    4 -
 sound/pci/hda/patch_realtek.c         |   33 +++++------
 sound/pci/oxygen/virtuoso.c           |    2 
 sound/usb/usbaudio.c                  |   14 ++++
 41 files changed, 370 insertions(+), 232 deletions(-)


Alan Stern (2):
      USB: EHCI: report actual_length for iso transfers
      USB: handle zero-length usbfs submissions correctly

Alexey Starikovskiy (1):
      ACPI: EC: Limit workaround for ASUS notebooks even more

Amerigo Wang (1):
      elf: fix one check-after-use

Andi Kleen (1):
      x86-64: Fix bad_srat() to clear all state

Anton Vorontsov (1):
      sky2: Fix checksum endianness

Clemens Ladisch (2):
      sound: usb-audio: add workaround for Blue Microphones devices
      sound: virtuoso: fix Xonar D1/DX silence after resume

David Brownell (2):
      USB: RNDIS gadget, fix issues talking from PXA
      usbnet cdc_subset: fix issues talking to PXA gadgets

David Dillow (1):
      r8169: avoid losing MSI interrupts

David S. Miller (1):
      x25: Fix sleep from timer on socket destroy.

Giuseppe Mazzotta (1):
      Input: wistron_btns - recognize Maxdata Pro 7000 notebooks

Greg Kroah-Hartman (2):
      USB: ti_usb_3410_5052: fix duplicate device ids.
      Linux 2.6.27.29

Herbert Xu (1):
      ipsec: Fix name of CAST algorithm

James Bottomley (1):
      SCSI: zalon: fix oops on attach failure

Jiri Slaby (2):
      HID: hiddev, fix lock imbalance
      hwmon: (max6650) Fix lock imbalance

Josef Bacik (1):
      mm: mark page accessed before we write_end()

Krzysztof Halasa (1):
      E100: work around the driver using streaming DMA mapping for RX descriptors.

Len Brown (1):
      ACPI: suspend: don't let device _PS3 failure prevent suspend

Linus Torvalds (1):
      x86: don't use 'access_ok()' as a range check in get_user_pages_fast()

Michael Buesch (1):
      pegasus usb-net: Fix endianness bugs

NeilBrown (1):
      md: avoid dereferencing NULL pointer when accessing suspend_* sysfs attributes.

Oliver Neukum (2):
      USB: fix memleak in usbfs
      USB: fix uninitialised variable in ti_do_download

Paul E. McKenney (1):
      fix RCU-callback-after-kmem_cache_destroy problem in sl[aou]b

Ralf Baechle (1):
      NET: Fix locking issues in PPP, 6pack, mkiss and strip line disciplines.

Ramon de Carvalho Valle (1):
      eCryptfs: parse_tag_3_packet check tag 3 packet encrypted key size (CVE-2009-2407)

Takashi Iwai (2):
      ALSA: ca0106 - Fix the max capture buffer size
      ALSA: hda - Fix mute control with some ALC262 models

Tilman Schmidt (1):
      gigaset: accept connection establishment messages in any order

Trond Myklebust (3):
      SUNRPC: Avoid an unnecessary task reschedule on ENOTCONN
      SUNRPC: Ensure we set XPRT_CLOSING only after we've sent a tcp FIN...
      SUNRPC: Don't disconnect if a connection is still in progress.

Tyler Hicks (1):
      eCryptfs: Check Tag 11 literal data buffer size (CVE-2009-2406)

Witold Szczeponik (1):
      Enable PNPACPI _PSx Support, v3

