Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905Ab0AZTYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab0AZTYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 14:24:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754899Ab0AZTYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 14:24:41 -0500
Received: from kroah.org ([198.145.64.141]:59936 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754864Ab0AZTYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 14:24:40 -0500
Date: Tue, 26 Jan 2010 11:17:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/11] 2.6.27.45 review
Message-ID: <20100126191730.GA20872@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.27.45 release.
There are 11 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Thursday, January 28, 20:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.45-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

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
 fs/reiserfs/inode.c                  |   17 ++++++++++++++---
 ipc/msg.c                            |    1 +
 ipc/sem.c                            |    1 +
 ipc/shm.c                            |    1 +
 17 files changed, 86 insertions(+), 26 deletions(-)
