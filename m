Return-Path: <linux-kernel-owner+w=401wt.eu-S1758564AbZJEH0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564AbZJEH0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 03:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758549AbZJEH0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 03:26:20 -0400
Received: from smtp.nokia.com ([192.100.105.134]:27639 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758547AbZJEH0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 03:26:19 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: eric.piel@tremplin-utc.net
Cc: linux-kernel@vger.kernel.org, Samu Onkalo <samu.p.onkalo@nokia.com>
Subject: [PATCH 0/2 try 2] LIS3LV02D I2C driver
Date: Mon,  5 Oct 2009 10:24:36 +0300
Message-Id: <1254727478-19802-1-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.5.6.3
X-OriginalArrivalTime: 05 Oct 2009 07:24:43.0002 (UTC) FILETIME=[E862FDA0:01CA458C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add I2C bus support for LIS3LV02D accelerometer driver
and possibility to use platform configurability for
remapping of device axes.

Changes are tested on linux-omap environment.
Applies to 2.6.32-rc3.

Samu Onkalo (2):
  LIS3LV02D: axis remap and resource setup / release
  LIS3LV02D: I2C support

 drivers/hwmon/Kconfig         |   17 ++++
 drivers/hwmon/Makefile        |    1 +
 drivers/hwmon/lis3lv02d_i2c.c |  184 +++++++++++++++++++++++++++++++++++++++++
 include/linux/lis3lv02d.h     |   12 +++
 4 files changed, 214 insertions(+), 0 deletions(-)
 create mode 100644 drivers/hwmon/lis3lv02d_i2c.c

