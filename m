Return-Path: <linux-kernel-owner+w=401wt.eu-S1753965AbYJCLuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbYJCLuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 07:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbYJCLui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 07:50:38 -0400
Received: from smtp.nokia.com ([192.100.105.134]:26983 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbYJCLuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 07:50:37 -0400
Subject: [RFC][PATCH 0/5] OMAP Synchronous Serial Interface (SSI) driver
From: Carlos Chinea <carlos.chinea@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org
Content-Type: text/plain
Date: Fri, 03 Oct 2008 14:50:06 +0300
Message-Id: <1223034606.32631.156.camel@groo.research.nokia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Oct 2008 11:50:33.0801 (UTC) FILETIME=[3E338390:01C9254E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys !

I'm working on adding support for Nokia HSPA modems to OMAP.

Please consider integrating the following patch set into the
linux-omap tree. The patch set implements a generic device driver
for the OMAP Synchronous Serial Interface. 

The Synchronous Serial Interface (SSI) is a high speed communication
interface that is used for connecting OMAP to a cellular modem engine.

The patch set is based on linux-omap 2.6.27-rc7.

Any comments will be appreciated.

Br,
Carlos



 Documentation/arm/OMAP/ssi/board-ssi.c.example     |  216 ++++++++
 Documentation/arm/OMAP/ssi/ssi                     |  232 +++++++++
 arch/arm/plat-omap/include/mach/ssi/ssi_gdd_reg.h  |  145 ++++++
 .../plat-omap/include/mach/ssi/ssi_reg_common.h    |   73 +++
 arch/arm/plat-omap/include/mach/ssi/ssi_ssr_reg.h  |   56 +++
 arch/arm/plat-omap/include/mach/ssi/ssi_sst_reg.h  |   65 +++
 arch/arm/plat-omap/include/mach/ssi/ssi_sys_reg.h  |  107 ++++
 drivers/misc/Kconfig                               |    2 +
 drivers/misc/Makefile                              |    1 +
 drivers/misc/ssi/Kconfig                           |   11 +
 drivers/misc/ssi/Makefile                          |    7 +
 drivers/misc/ssi/ssi_driver.c                      |  513 ++++++++++++++++++++
 drivers/misc/ssi/ssi_driver.h                      |  211 ++++++++
 drivers/misc/ssi/ssi_driver_bus.c                  |  192 ++++++++
 drivers/misc/ssi/ssi_driver_dma.c                  |  406 ++++++++++++++++
 drivers/misc/ssi/ssi_driver_if.c                   |  335 +++++++++++++
 drivers/misc/ssi/ssi_driver_int.c                  |  232 +++++++++
 include/linux/ssi_driver_if.h                      |  137 ++++++
 18 files changed, 2941 insertions(+), 0 deletions(-)


