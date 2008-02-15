Return-Path: <linux-kernel-owner+w=401wt.eu-S1760745AbYCVCjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760745AbYCVCjx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 22:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757233AbYCVCiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 22:38:18 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:18672 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756996AbYCVCiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 22:38:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:references:to:date:message-id:sender;
        b=Fzez0AsRdpDILwh2t157x7LFwmD/AMKeWBh9bhvV1uFpiUmdBnL1PAjaSdlNWtQ8l1NxEVXzDDY9RSFcAE6rAXERE0liSIlGhs/7AN2a9aGTAUGZOyX1Dcy7OzpTYIx9EzCujBtUrQzNR7fakrsPV6cnxDDSIdEKpfLK8NqRtOM=
Subject: [RFC][PATCH 9/9] cgroups: block: cfq: I/O bandwidth controlling subsystem for CGroups based on CFQ
From: Vasily Tarasov <vtaras@openvz.org>
References: <1203058414.042372.2088.nullmailer@me>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, devel@openvz.org,
       containers@linux-foundation.com, dev@openvz.org, xemul@openvz.org
Date: Fri, 15 Feb 2008 01:59:58 -0500
Message-Id: <1203058798.326998.2153.nullmailer@me>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasily Tarasov <vtaras@openvz.org>

Adds the description to the Kconfig file.

Signed-off-by: Vasily Tarasov <vtaras@openvz.org>

---

--- linux-2.6.25-rc5-mm1/init/Kconfig.kconfig	2008-02-15 01:01:40.000000000 -0500
+++ linux-2.6.25-rc5-mm1/init/Kconfig	2008-02-15 01:13:12.000000000 -0500
@@ -316,6 +316,13 @@ config GROUP_SCHED
 	  This feature lets CPU scheduler recognize task groups and control CPU
 	  bandwidth allocation to such task groups.
 
+config CGROUP_CFQIO
+	bool "CFQIO cgroup subsystem"
+	depends on CGROUPS && IOSCHED_CFQ=y
+	help
+	  This feature allows CFQ I/O scheduler recognize cgroups and
+	  control I/O bandwidth allocation to cgroups.
+
 config FAIR_GROUP_SCHED
 	bool "Group scheduling for SCHED_OTHER"
 	depends on GROUP_SCHED
