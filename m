Return-Path: <linux-kernel-owner+w=401wt.eu-S1762345AbZLKLcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762345AbZLKLcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 06:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762313AbZLKLcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 06:32:12 -0500
Received: from smtp.nokia.com ([192.100.122.233]:50297 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970AbZLKLcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 06:32:12 -0500
From: Felipe Balbi <felipe.balbi@nokia.com>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>, linux-omap@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: [RFC/PATCH 0/5] usb transceiver notifier
Date: Fri, 11 Dec 2009 13:31:21 +0200
Message-Id: <1260531086-23857-1-git-send-email-felipe.balbi@nokia.com>
X-Mailer: git-send-email 1.6.6.rc0
In-Reply-To: <6ed0b2680912101251jeec28e6i216dfc51caab13aa@mail.gmail.com>
References: <6ed0b2680912101251jeec28e6i216dfc51caab13aa@mail.gmail.com>
X-OriginalArrivalTime: 11 Dec 2009 11:31:41.0905 (UTC) FILETIME=[82D16410:01CA7A55]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches are a prototype for supporting
notification of some usb events to whoever is interested
in them.

This way we can communicate common usb events to several
interested drivers so they can e.g. kick usb charger detection
and configure charging with proper input current.

THEY ARE NOT READY AND ARE NOT SUPPOSED TO BE APPLIED TO ANY
BRANCH.

please comment.

ps: patches were compile tested only.

Felipe Balbi (5):
  usb: otg: add notifier support
  usb: otg: twl4030: add support for notifier
  usb: musb: add support for ulpi block
  usb: musb: isp1704: add registers from isp1704
  usb: musb: musb supports otg notifier

 drivers/usb/musb/isp1704.h    |   81 +++++++++++++++++++++++++++++++++++++++++
 drivers/usb/musb/musb_core.c  |   72 ++++++++++++++++++++++++++++++++++++
 drivers/usb/musb/musb_core.h  |    5 +++
 drivers/usb/musb/musb_regs.h  |   62 +++++++++++++++++++++++++++++++
 drivers/usb/otg/twl4030-usb.c |    7 +++-
 include/linux/usb/otg.h       |   25 +++++++++++++
 6 files changed, 250 insertions(+), 2 deletions(-)
 create mode 100644 drivers/usb/musb/isp1704.h

