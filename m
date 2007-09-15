Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbXIOH3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbXIOH3Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 03:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbXIOH3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 03:29:08 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49222 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751239AbXIOH3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 03:29:07 -0400
From: Paul Jackson <pj@sgi.com>
To: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org
Date: Sat, 15 Sep 2007 00:29:04 -0700
Message-Id: <20070915072904.30468.73201.sendpatchset@jackhammer.engr.sgi.com>
Subject: [PATCH] task containersv11 enable containers by default in some configs
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

Paul Menage - in pre-container cpusets, a few config files enabled
cpusets by default.  Could you blend the following patch into your
container patch set, so that cpusets continue to be configured by
default for those same configurations?

Thanks - pj.

Signed-off-by: Paul Jackson <pj@sgi.com>

---

 arch/ia64/configs/sn2_defconfig          |    1 +
 arch/mips/configs/ip27_defconfig         |    1 +
 arch/mips/configs/sb1250-swarm_defconfig |    1 +
 arch/powerpc/configs/cell_defconfig      |    1 +
 arch/powerpc/configs/ppc64_defconfig     |    1 +
 arch/powerpc/configs/pseries_defconfig   |    1 +
 6 files changed, 6 insertions(+)

--- 2.6.23-rc4-mm1.orig/arch/ia64/configs/sn2_defconfig	2007-09-13 15:17:47.412216707 -0700
+++ 2.6.23-rc4-mm1/arch/ia64/configs/sn2_defconfig	2007-09-13 17:53:15.363009794 -0700
@@ -27,6 +27,7 @@ CONFIG_TASKSTATS=y
 # CONFIG_UTS_NS is not set
 # CONFIG_AUDIT is not set
 # CONFIG_IKCONFIG is not set
+CONFIG_CONTAINERS=y
 CONFIG_CPUSETS=y
 CONFIG_RELAY=y
 CONFIG_INITRAMFS_SOURCE=""
--- 2.6.23-rc4-mm1.orig/arch/mips/configs/ip27_defconfig	2007-09-13 15:17:57.968367923 -0700
+++ 2.6.23-rc4-mm1/arch/mips/configs/ip27_defconfig	2007-09-13 17:54:09.743831694 -0700
@@ -175,6 +175,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=15
+CONFIG_CONTAINERS=y
 CONFIG_CPUSETS=y
 CONFIG_SYSFS_DEPRECATED=y
 CONFIG_RELAY=y
--- 2.6.23-rc4-mm1.orig/arch/mips/configs/sb1250-swarm_defconfig	2007-09-13 15:17:58.184371018 -0700
+++ 2.6.23-rc4-mm1/arch/mips/configs/sb1250-swarm_defconfig	2007-09-13 17:53:15.395010278 -0700
@@ -197,6 +197,7 @@ CONFIG_SYSVIPC_SYSCTL=y
 # CONFIG_UTS_NS is not set
 # CONFIG_AUDIT is not set
 # CONFIG_IKCONFIG is not set
+CONFIG_CONTAINERS=y
 CONFIG_CPUSETS=y
 CONFIG_SYSFS_DEPRECATED=y
 CONFIG_RELAY=y
--- 2.6.23-rc4-mm1.orig/arch/powerpc/configs/cell_defconfig	2007-09-13 15:18:07.816509023 -0700
+++ 2.6.23-rc4-mm1/arch/powerpc/configs/cell_defconfig	2007-09-13 17:53:15.411010519 -0700
@@ -68,6 +68,7 @@ CONFIG_SYSVIPC_SYSCTL=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=15
+CONFIG_CONTAINERS=y
 CONFIG_CPUSETS=y
 CONFIG_SYSFS_DEPRECATED=y
 # CONFIG_RELAY is not set
--- 2.6.23-rc4-mm1.orig/arch/powerpc/configs/ppc64_defconfig	2007-09-13 15:28:41.533723431 -0700
+++ 2.6.23-rc4-mm1/arch/powerpc/configs/ppc64_defconfig	2007-09-13 17:53:15.431010822 -0700
@@ -71,6 +71,7 @@ CONFIG_TASK_DELAY_ACCT=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=17
+CONFIG_CONTAINERS=y
 CONFIG_CPUSETS=y
 CONFIG_SYSFS_DEPRECATED=y
 CONFIG_RELAY=y
--- 2.6.23-rc4-mm1.orig/arch/powerpc/configs/pseries_defconfig	2007-09-13 15:28:41.565723900 -0700
+++ 2.6.23-rc4-mm1/arch/powerpc/configs/pseries_defconfig	2007-09-13 17:53:15.447011064 -0700
@@ -71,6 +71,7 @@ CONFIG_AUDITSYSCALL=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=17
+CONFIG_CONTAINERS=y
 CONFIG_CPUSETS=y
 CONFIG_SYSFS_DEPRECATED=y
 # CONFIG_RELAY is not set

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
