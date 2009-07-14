Return-Path: <linux-kernel-owner+w=401wt.eu-S1752976AbZGNM7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbZGNM7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 08:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbZGNM7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 08:59:23 -0400
Received: from smtp.nokia.com ([192.100.105.134]:48921 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbZGNM7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 08:59:20 -0400
From: Tiago Vignatti <tiago.vignatti@nokia.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@redhat.com>, <linux-pci@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>,
       Tiago Vignatti <tiago.vignatti@nokia.com>
Subject: [PATCH 0/2] VGA arbiter implementation
Date: Tue, 14 Jul 2009 15:57:28 +0300
Message-Id: <1247576250-16274-1-git-send-email-tiago.vignatti@nokia.com>
X-Mailer: git-send-email 1.5.6.3
X-OriginalArrivalTime: 14 Jul 2009 12:58:52.0921 (UTC) FILETIME=[D6C89690:01CA0482]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So here finally is, Jesse! 

I've cooked this set against linux-2.6 linus's tree (7638d532). Please point 
me out if I need to apply to some other tree.


Thank you,

                Tiago


Tiago Vignatti (2):
  vga: implements VGA arbitration on Linux
  vga: drops a documentation regarding the VGA arbiter

 Documentation/vgaarbiter.txt |  197 ++++++++
 drivers/gpu/Makefile         |    2 +-
 drivers/gpu/vga/Kconfig      |    8 +
 drivers/gpu/vga/Makefile     |    1 +
 drivers/gpu/vga/vgaarb.c     | 1120 ++++++++++++++++++++++++++++++++++++++++++
 drivers/gpu/vga/vgaarb.h     |  168 +++++++
 drivers/video/Kconfig        |    2 +
 7 files changed, 1497 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/vgaarbiter.txt
 create mode 100644 drivers/gpu/vga/Kconfig
 create mode 100644 drivers/gpu/vga/Makefile
 create mode 100644 drivers/gpu/vga/vgaarb.c
 create mode 100644 drivers/gpu/vga/vgaarb.h

