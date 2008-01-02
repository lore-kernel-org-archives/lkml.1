Return-Path: <linux-kernel-owner+w=401wt.eu-S1760454AbYGUEhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760454AbYGUEhz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 00:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbYGUEhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 00:37:47 -0400
Received: from www.swissdisk.com ([216.66.254.197]:32856 "EHLO
	swissweb.swissdisk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbYGUEhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 00:37:46 -0400
X-Greylist: delayed 2592 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jul 2008 00:37:46 EDT
From: Ben Collins <ben.collins@canonical.com>
Date: Wed, 2 Jan 2008 08:57:35 -0700
Subject: [PATCH 0/7] Patches from Ubuntu kernel tree
To: linux-kernel@vger.kernel.org
Message-ID: <24762.90.138.930.038.1036103001.ben.collins@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following is a set of patches collected from our tree. They are
available from:

	git.kernel.org:/pub/scm/linux/kernel/git/bcollins/linux-ubuntu#for-linus

NOTE: Contrary to the branch name, this isn't meant to be pulled
wholesale.

Alexandre Karpenko (1):
      HID: Add quirks for fourth generation MacBooks (4,1)

Ben Collins (3):
      bluetooth: Add quirks for a few hci_usb devices
      [airprime] Add support for more devices
      pm: Config option to disable handling of console during suspend/resume

Chuck Short (1):
      ata: blacklist FUJITSU MHW2160BH PL

Matthew Garrett (1):
      irda: Default to dongle type 9 on IBM hardware

Tim Gardner (1):
      netfilter: Export ip6t_mh.h and xt_quota.h for iptables build

 drivers/ata/libata-core.c           |    1 +
 drivers/bluetooth/hci_usb.c         |    7 +++++++
 drivers/hid/usbhid/hid-quirks.c     |   13 ++++++++++++-
 drivers/net/irda/nsc-ircc.c         |    5 ++++-
 drivers/usb/serial/airprime.c       |    9 +++++++++
 include/linux/netfilter/Kbuild      |    2 ++
 include/linux/netfilter_ipv6/Kbuild |    1 +
 kernel/power/Kconfig                |   15 +++++++++++++++
 kernel/power/console.c              |    4 ++++
 9 files changed, 55 insertions(+), 2 deletions(-)
