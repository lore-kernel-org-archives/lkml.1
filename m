Return-Path: <linux-kernel-owner+w=401wt.eu-S1756472Ab0A1XiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472Ab0A1XiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 18:38:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753919Ab0A1XiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 18:38:08 -0500
Received: from kroah.org ([198.145.64.141]:46840 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756403Ab0A1Xh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 18:37:58 -0500
Date: Thu, 28 Jan 2010 15:36:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.27.45
Message-ID: <20100128233645.GC18110@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.27.45 kernel.  All users of the
2.6.27 kernel series are very strongly encouraged to upgrade.

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                             |    2 +-
 arch/s390/kvm/intercept.c            |    4 ++--
 drivers/char/tty_io.c                |    2 +-
 drivers/edac/i5000_edac.c            |    8 +++++++-
 drivers/scsi/megaraid/megaraid_sas.c |    2 +-
 drivers/usb/core/hub.c               |    3 +++
 drivers/usb/host/ehci-hcd.c          |    5 +++--
 drivers/usb/host/ehci-hub.c          |   20 +++++++++++++++++++-
 drivers/usb/host/ehci-q.c            |   11 ++++++++---
 drivers/usb/host/uhci-hcd.c          |   15 ++++++++++++++-
 drivers/usb/host/uhci-hub.c          |    2 +-
 fs/ecryptfs/crypto.c                 |    4 ++--
 fs/ecryptfs/file.c                   |   14 +++++++-------
 fs/fcntl.c                           |    6 ++++--
 fs/reiserfs/inode.c                  |   17 ++++++++++++++---
 ipc/msg.c                            |    1 +
 ipc/sem.c                            |    1 +
 ipc/shm.c                            |    1 +
 18 files changed, 90 insertions(+), 28 deletions(-)

Alan Stern (3):
      USB: add missing delay during remote wakeup
      USB: EHCI: fix handling of unusual interrupt intervals
      USB: EHCI & UHCI: fix race between root-hub suspend and port resume

Bryn M. Reeves (1):
      megaraid_sas: remove sysfs poll_mode_io world writeable permissions

Christian Borntraeger (1):
      KVM: S390: fix potential array overrun in intercept handling

Dan Carpenter (1):
      ecryptfs: use after free

Erez Zadok (1):
      ecryptfs: initialize private persistent file before dereferencing pointer

Greg Kroah-Hartman (3):
      tty: fix race in tty_fasync
      fnctl: f_modown should call write_lock_irqsave/restore
      Linux 2.6.27.45

Jan Kara (1):
      reiserfs: truncate blocks not used by a write

Serge E. Hallyn (1):
      ipc ns: fix memory leak (idr)

Tamas Vincze (1):
      edac: i5000_edac critical fix panic out of bounds

