Return-Path: <linux-kernel-owner+w=401wt.eu-S932259AbZJAMZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259AbZJAMZu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 08:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932171AbZJAMZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 08:25:48 -0400
Received: from smtp.nokia.com ([192.100.122.230]:47649 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932149AbZJAMZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 08:25:46 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: akpm@linux-foundation.org, daniel@caiaq.de
Cc: eric.piel@tremplin-utc.net, linux-kernel@vger.kernel.org,
       Samu Onkalo <samu.p.onkalo@nokia.com>
Subject: [PATCH 0/1] LIS3LV02D_SPI incomplete module unloading
Date: Thu,  1 Oct 2009 15:25:23 +0300
Message-Id: <1254399924-30921-1-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.5.6.3
X-OriginalArrivalTime: 01 Oct 2009 12:25:29.0770 (UTC) FILETIME=[437240A0:01CA4292]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While implementing I2C driver for LIS3LV02D, following bug was found
from corresponding SPI implementation. This is not tested with real
HW where LIS3 is connected via SPI since I don't have one.
However, module loading and unloading is tested with dummy SPI configuration.

Patch created to top of 2.6.32-RC1

Samu Onkalo (1):
  LIS3LV02D_SPI: Module unload didn't remove sysfs entry

 drivers/hwmon/lis3lv02d_spi.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

