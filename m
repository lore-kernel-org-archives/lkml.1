Return-Path: <linux-kernel-owner+w=401wt.eu-S1756879AbZCTNxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbZCTNxV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 09:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbZCTNxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 09:53:06 -0400
Received: from smtp.nokia.com ([192.100.122.233]:18434 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbZCTNxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 09:53:06 -0400
From: Jani Nikula <ext-jani.1.nikula@nokia.com>
To: david-b@pacbell.net
Cc: linux-kernel@vger.kernel.org, juha.yrjola@solidboot.com,
       ext-jani.1.nikula@nokia.com
Subject: [RFC PATCH 0/3] GPIO switch framework
Date: Fri, 20 Mar 2009 15:50:47 +0200
Message-Id: <1237557050-13742-1-git-send-email-ext-jani.1.nikula@nokia.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 20 Mar 2009 13:51:44.0594 (UTC) FILETIME=[01547B20:01C9A963]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi -

This RFC patchset is a pretty straightforward adaptation of OMAP GPIO
switch framework for mainline integration.

The GPIO switch framework allows reporting and changing GPIO switches
via sysfs, with debouncing and sysfs/in-kernel notifications for input
switches.

The switches are added as /sys/class/gpio/switch-<switch name> under
the gpiolib sysfs structure.


BR,
Jani.


Jani Nikula (3):
      GPIOLIB: Add new gpio_device_create function
      GPIO-SWITCH: Adaptation of GPIO switch framework for mainline
      GPIO-SWITCH: Kconfig and Makefile

 drivers/gpio/Kconfig        |   10 +
 drivers/gpio/Makefile       |    2 +
 drivers/gpio/gpio-switch.c  |  534 +++++++++++++++++++++++++++++++++++++++++++
 drivers/gpio/gpiolib.c      |   52 +++++
 include/asm-generic/gpio.h  |   12 +
 include/linux/gpio-switch.h |   74 ++++++
 6 files changed, 684 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/gpio-switch.c
 create mode 100644 include/linux/gpio-switch.h
