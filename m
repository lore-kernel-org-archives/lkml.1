Return-Path: <linux-kernel-owner+w=401wt.eu-S1752295AbZK3Lpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295AbZK3Lpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 06:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbZK3Lpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 06:45:31 -0500
Received: from smtp.nokia.com ([192.100.105.134]:55299 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbZK3Lpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 06:45:30 -0500
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: List Linux Kernel <linux-kernel@vger.kernel.org>
Cc: rui.zhang@intel.com, jic23@cam.ac.uk, khali@linux-fr.org,
       alan@linux.intel.com, linux-acpi@vger.kernel.org, gregkh@suse.de
Subject: [PATCHv2 0/2] Introducing the Ambient Light Sensor (ALS) class
Date: Mon, 30 Nov 2009 13:45:14 +0200
Message-Id: <1259581514-15356-1-git-send-email-amit.kucheria@verdurent.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 30 Nov 2009 11:45:08.0510 (UTC) FILETIME=[910C4BE0:01CA71B2]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a new class of devices to handle ambient light sensors. Currently
only one sysfs inteface, 'illuminance' is introduced. More will be added as
drivers are ported to use this new class.

Amit Kucheria (1):
  als: add unique device-ids to the als device class

Zhang Rui (1):
  introduce ALS sysfs class

 Documentation/ABI/testing/sysfs-class-als |    9 ++
 MAINTAINERS                               |    6 ++
 drivers/Kconfig                           |    2 +
 drivers/Makefile                          |    1 +
 drivers/als/Kconfig                       |   10 +++
 drivers/als/Makefile                      |    5 +
 drivers/als/als_sys.c                     |  116 +++++++++++++++++++++++++++++
 include/linux/als_sys.h                   |   35 +++++++++
 8 files changed, 184 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-als
 create mode 100644 drivers/als/Kconfig
 create mode 100644 drivers/als/Makefile
 create mode 100644 drivers/als/als_sys.c
 create mode 100644 include/linux/als_sys.h

