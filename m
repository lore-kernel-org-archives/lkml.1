Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab0CIRwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 12:52:47 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:4615 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab0CIRwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:52:45 -0500
Subject: [PATCH 0/2] small xhci cleanups
To: sarah.a.sharp@linux.intel.com
From: Alex Chiang <achiang@hp.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 09 Mar 2010 10:52:43 -0700
Message-ID: <20100309174815.29339.96173.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While trying to render aid and assistance for a USB3 issue that Sarah
has been chasing, she grumbled in a private email that she was unable
to coerce the build system to produce a module named "xhci_hcd".

This patch series shows one way to get around the Makefile intrinsics
and create a module name of our choosing. There's probably a better
way to do it, but it's beyond my makefile-fu.

The other change is to move all the debug code under
CONFIG_XHCI_HCD_DEBUGGING, which is a straightforward change.

Thanks,
/ac

---

Alex Chiang (2):
      USB: xhci: rename driver to xhci_hcd
      USB: xhci: move all debug code under CONFIG_XHCI_HCD_DEBUGGING


 drivers/usb/host/Makefile   |    7 
 drivers/usb/host/xhci-dbg.c |   76 ++
 drivers/usb/host/xhci-hcd.c | 1806 -------------------------------------------
 drivers/usb/host/xhci.c     | 1736 +++++++++++++++++++++++++++++++++++++++++
 drivers/usb/host/xhci.h     |   19 
 5 files changed, 1836 insertions(+), 1808 deletions(-)
 delete mode 100644 drivers/usb/host/xhci-hcd.c
 create mode 100644 drivers/usb/host/xhci.c

