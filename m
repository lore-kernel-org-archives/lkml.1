Return-Path: <linux-kernel-owner+w=401wt.eu-S1758185AbZBBS6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185AbZBBS6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 13:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754312AbZBBS6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 13:58:17 -0500
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:34565 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754AbZBBS6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 13:58:16 -0500
X-Greylist: delayed 2896 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Feb 2009 13:58:15 EST
Message-ID: <49873632.6040108@csr.com>
Date: Mon, 02 Feb 2009 18:06:42 +0000
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] UWB and WUSB fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Feb 2009 18:06:42.0124 (UTC) FILETIME=[005DD0C0:01C98561]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This handful of changes fix a number of oopses and other serious bugs
when using devices that don't quite behave as expected.

The following changes since commit 45c82b5a770be66845687a7d027c8b52946d59af:
  Linus Torvalds (1):
        Merge branch 'header-fixes-for-linus' of
git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dvrabel/uwb.git for-upstream

David Vrabel (7):
      uwb: safely remove all reservations
      wusb: return -ENOTCONN when resetting a port with no connected device
      wusb: timeout when waiting for ASL/PZL updates in whci-hcd
      uwb: lock rc->rsvs_lock with spin_lock_bh()

Huang Weiyi (1):
      uwb: remove unused #include <version.h>'s

 drivers/usb/host/whci/asl.c       |    9 +++++++--
 drivers/usb/host/whci/hw.c        |   15 +++++++++++++++
 drivers/usb/host/whci/pzl.c       |    9 +++++++--
 drivers/usb/host/whci/whcd.h      |    1 +
 drivers/usb/wusbcore/devconnect.c |    1 +
 drivers/usb/wusbcore/rh.c         |    3 +++
 drivers/uwb/allocator.c           |    1 -
 drivers/uwb/drp.c                 |    4 ++--
 drivers/uwb/rsv.c                 |   21 +++++++++++++++------
 9 files changed, 51 insertions(+), 13 deletions(-)

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/
