Return-Path: <linux-kernel-owner+w=401wt.eu-S1761919AbYAYIGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761919AbYAYIGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:06:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763660AbYAYH7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:59:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53539 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764050AbYAYH7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:41 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 182/196] sysfs: make SYSFS_DEPRECATED depend on SYSFS
Date: Thu, 24 Jan 2008 23:33:31 -0800
Message-Id: <1201246425-5058-103-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Make SYSFS_DEPRECATED depend on SYSFS since files that check
CONFIG_SYSFS_DEPRECATED don't check for CONFIG_SYSFS first.
Also don't prompt user about SYSFS_DEPRECATED if SYSFS=n.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 init/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index b9d11a8..f5becd2 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -363,6 +363,7 @@ config CGROUP_CPUACCT
 
 config SYSFS_DEPRECATED
 	bool "Create deprecated sysfs files"
+	depends on SYSFS
 	default y
 	help
 	  This option creates deprecated symlinks such as the
-- 
1.5.3.8

