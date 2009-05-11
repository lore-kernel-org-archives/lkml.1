Return-Path: <linux-kernel-owner+w=401wt.eu-S1759216AbZEKUZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759216AbZEKUZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 16:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758613AbZEKUZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 16:25:09 -0400
Received: from mail.windriver.com ([147.11.1.11]:52579 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754909AbZEKUZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 16:25:07 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: greg@kroah.com
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] usb_debug serial, ftdi_sio serial and sysrq
Date: Mon, 11 May 2009 15:24:06 -0500
Message-Id: <1242073450-3794-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
X-OriginalArrivalTime: 11 May 2009 20:25:04.0887 (UTC) FILETIME=[91AE6870:01C9D276]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idea behind this patch series is to allow the USB 2.0 debug device
to better operate as a fully functional system console with the full
capability for sysrq.

This is version 2 of the original patches per Greg and Alan's comments.

Included is a fix to the ftdi_sio driver as well.

Thanks,
Jason.


The short log and git info is below, which is against the 2.6.30
development tree.
The following changes since commit a4d7749be5de4a7261bcbe3c7d96c748792ec455:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../gregkh/staging-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_gregkh

Jason Wessel (4):
      usb_debug, usb_generic_serial: implement multi urb write
      ftd_sio usb: move status check
      usb_debug,usb_generic_serial: implement sysrq and serial break
      ftd_sio usb: implement sysrq handling on break

 drivers/usb/serial/Kconfig     |    7 ++
 drivers/usb/serial/ftdi_sio.c  |   18 +++--
 drivers/usb/serial/generic.c   |  151 +++++++++++++++++++++++++++++++++++-----
 drivers/usb/serial/usb_debug.c |   41 +++++++++++
 include/linux/usb/serial.h     |   38 ++++++++++-
 5 files changed, 227 insertions(+), 28 deletions(-)
