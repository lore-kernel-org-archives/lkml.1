Return-Path: <linux-kernel-owner+w=401wt.eu-S2992850AbXCCBOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992850AbXCCBOD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 20:14:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992851AbXCCBOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 20:14:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34014 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992850AbXCCBOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 20:14:00 -0500
Date: Fri, 2 Mar 2007 17:13:08 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@osdl.org>, torvalds@osdl.org, stable@kernel.org
Subject: Linux 2.6.19.6
Message-ID: <20070303011308.GA6439@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.19.6 kernel.
It contains a number of bugfixes, and all 2.6.19 users are recommended
to upgrade.

Barring anything major, there will not be any more 2.6.19 releases.  If
you disagree with this, please let the stable team know about the
patches that you feel must be in a new release.  We need to move on to
flushing out the very large backlog of 2.6.20-stable patches.

The diffstat and short summary of the fixes are below.

I'll also be replying to this message with a copy of the patch between
2.6.19.5 and 2.6.19.6, as it is small enough to do so.

The updated 2.6.19.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.19.y.git
and can be browsed at the normal kernel.org git web browser:
        www.kernel.org/git/

thanks,

greg k-h
--------

 Makefile                           |    2 
 drivers/input/mouse/psmouse-base.c |   28 +++
 drivers/input/mouse/psmouse.h      |    1 
 drivers/input/mouse/synaptics.c    |    1 
 drivers/net/8139cp.c               |    6 
 drivers/net/b44.c                  |    6 
 drivers/net/forcedeth.c            |   11 -
 drivers/net/skge.c                 |    5 
 drivers/net/sky2.c                 |   51 +++--
 drivers/net/sky2.h                 |    2 
 drivers/usb/net/usbnet.c           |    7 
 fs/bad_inode.c                     |  330 ++++++++++++++++++++++++++++++++-----
 fs/cifs/sess.c                     |   13 -
 fs/ext2/super.c                    |    4 
 fs/ext3/super.c                    |    4 
 fs/ext4/super.c                    |    4 
 lib/swiotlb.c                      |    2 
 sound/pci/hda/hda_intel.c          |    2 
 sound/pci/hda/patch_si3054.c       |    3 
 19 files changed, 400 insertions(+), 82 deletions(-)

Summary of changes from v2.6.19.5 to v2.6.19.6
==============================================

David Brownell (1):
      USB: usbnet driver bugfix

David Moore (1):
      Missing critical phys_to_virt in lib/swiotlb.c

Eric Sandeen (1):
      fix memory corruption from misinterpreted bad_inode_ops return values (CVE-2006-5753)

Francois Romieu (1):
      netpoll: drivers must not enable IRQ unconditionally in their NAPI handler

Greg Kroah-Hartman (1):
      Linux 2.6.19.6

Hugh Dickins (1):
      fix umask when noACL kernel meets extN tuned for ACLs

Stephen Hemminger (6):
      sky2: pci config blocks phy power control
      sky2: fix for NAPI with dual port boards
      sky2: kfree_skb with IRQ with netconsole
      sky2: transmit timeout deadlock
      sky2: dont flush good pause frames
      sky2: fix ram buffer allocation settings

Steve French (1):
      Fix oops when Windows server sent bad domain name null terminator

Takashi Iwai (2):
      hda-intel - Don't try to probe invalid codecs
      hda-codec - Don't return error at initialization of modem codec

Thomas Renninger (1):
      Backport of psmouse suspend/shutdown cleanups

