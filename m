Return-Path: <linux-kernel-owner+w=401wt.eu-S1755581AbZF0FTC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbZF0FTC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 01:19:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbZF0FSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 01:18:49 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:48895 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbZF0FSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 01:18:49 -0400
From: =?utf-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
To: linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, linux-input@vger.kernel.org,
       jbarnes@virtuousgeek.org,
       =?utf-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH 0/2] Winbond IR driver
Date: Sat, 27 Jun 2009 07:18:30 +0200
Message-Id: <1246079912-17619-1-git-send-email-david@hardeman.nu>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following two patches reintroduce the acpi .shutdown method
which was removed prior to the release of 2.6.30 and then adds
a driver for the IR functionality of the Winbond WPCD376I 
SuperI/O chip found on some Intel motherboards.

acpi shutdown was removed in commit
c0ce093f5b8bc3262c51bd0b5900424a67909831

David Härdeman (2):
  ACPI: reintroduce acpi_device_ops .shutdown method
  Add a driver for the Winbond WPCD376I IR functionality.

 MAINTAINERS                      |    6 +
 drivers/acpi/scan.c              |   12 +
 drivers/input/misc/Kconfig       |   15 +
 drivers/input/misc/Makefile      |    1 +
 drivers/input/misc/winbond-cir.c | 1693 ++++++++++++++++++++++++++++++++++++++
 include/acpi/acpi_bus.h          |    2 +
 6 files changed, 1729 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/misc/winbond-cir.c

