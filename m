Return-Path: <linux-kernel-owner+w=401wt.eu-S932708AbYEAWGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932708AbYEAWGK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 18:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756848AbYEAWF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 18:05:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40722 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756478AbYEAWF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 18:05:56 -0400
Date: Thu, 1 May 2008 15:03:35 -0700
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.24.6
Message-ID: <20080501220335.GC28881@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.24.6 kernel.

If fixes a number of different bugs and some security issues so that all
users of the 2.6.24 series of kernels are strongly encouraged to
upgrade.

Note, barring some major security issue, this is probably going to be
the last 2.6.24 kernel released.  You all should move on to the 2.6.25
series by now.

I'll also be replying to this message with a copy of the patch between
2.6.24.5 and 2.6.24.6

The updated 2.6.24.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.24.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.24.y.git;a=summary

thanks,

greg k-h

--------

 Makefile                              |    2 +-
 arch/x86/kernel/io_apic_32.c          |    1 +
 drivers/isdn/capi/capidrv.c           |    9 +++++----
 drivers/isdn/i4l/isdn_net.c           |    1 +
 drivers/media/video/cx88/cx88-cards.c |    4 ++++
 drivers/media/video/ivtv/ivtv-ioctl.c |    3 ++-
 drivers/net/tehuti.c                  |   15 +++++++++++++++
 drivers/usb/gadget/ether.c            |    1 +
 drivers/usb/serial/usb-serial.c       |    2 ++
 fs/dnotify.c                          |   11 +++++++++++
 fs/jffs2/erase.c                      |   18 ++++++++----------
 fs/splice.c                           |    2 +-
 include/net/tcp.h                     |    7 +++++--
 13 files changed, 57 insertions(+), 19 deletions(-)



Al Viro (1):
      Fix dnotify/close race (CVE-2008-1375)

Alan Cox (1):
      V4L: Fix VIDIOCGAP corruption in ivtv

David Woodhouse (1):
      JFFS2: Fix free space leak with in-band cleanmarkers

Francois Romieu (1):
      tehuti: check register size (CVE-2008-1675)

Greg Kroah-Hartman (2):
      USB: remove broken usb-serial num_endpoints check
      Linux 2.6.24.6

Hugh Dickins (1):
      splice: use mapping_gfp_mask

Jan Altenberg (1):
      USB: gadget: queue usb USB_CDC_GET_ENCAPSULATED_RESPONSE message

Jeff Garzik (1):
      tehuti: move ioctl perm check closer to function start (CVE-2008-1675)

John Heffner (1):
      Increase the max_burst threshold from 3 to tp->reordering.

Karsten Keil (1):
      fix oops on rmmod capidrv

PJ Waskiewicz (1):
      x86: Fix 32-bit x86 MSI-X allocation leakage

Paul Bolle (1):
      ISDN: Do not validate ISDN net device address prior to interface-up

Steven Toth (1):
      V4L: cx88: enable radio GPIO correctly

