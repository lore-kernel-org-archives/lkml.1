Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbZDZJTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbZDZJTA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 05:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbZDZJSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 05:18:17 -0400
Received: from cathcart.site5.com ([74.54.107.137]:46401 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbZDZJSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 05:18:15 -0400
From: Mike Rapoport <mike@compulab.co.il>
To: broonie@opensource.wolfsonmicro.com
Cc: lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org,
       Mike Rapoport <mike@compulab.co.il>
Subject: [PATCH 0/2] regulator: add userspace-consumer driver
Date: Sun, 26 Apr 2009 12:17:21 +0300
Message-Id: <cover.1240736991.git.mike@compulab.co.il>
X-Mailer: git-send-email 1.5.6.4
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The userspace-consumer driver allows control of voltage and current
regulator state from userspace. This is required for fine-grained power
management of devices that are completely controller by userspace
applications, e.g. a GPS transciever connected to a serial port.

The first patch in the serie reorginases the way structs are defined in
the regulator framework headers so that regulator_consumer_supply can be
used without need to include include/linux/regulator/machine.h

The second patch is actully userspace-consumer driver implementation.

Mike Rapoport (2):
  regulator: move regulator_consumer_supply from machine.h to
    consumer.h
  regulator: add userspace-consumer driver

 drivers/regulator/Kconfig                    |   10 ++
 drivers/regulator/Makefile                   |    1 +
 drivers/regulator/userspace-consumer.c       |  213 ++++++++++++++++++++++++++
 include/linux/regulator/consumer.h           |   13 ++
 include/linux/regulator/machine.h            |   14 +--
 include/linux/regulator/userspace-consumer.h |   25 +++
 6 files changed, 263 insertions(+), 13 deletions(-)
 create mode 100644 drivers/regulator/userspace-consumer.c
 create mode 100644 include/linux/regulator/userspace-consumer.h

