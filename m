Return-Path: <linux-kernel-owner+w=401wt.eu-S1756849AbYBWX1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbYBWX1m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 18:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbYBWX0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 18:26:53 -0500
Received: from smtp-out.google.com ([216.239.45.13]:39424 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbYBWX0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 18:26:51 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:references:user-agent:date:from:to:cc:
	subject:content-disposition;
	b=jeAtlroT3OWNCzzjRCN+JJBAcqaDL/50JzItY+u7rHGIMj53K+UhPfmqHa2EbhLvx
	SmGunLUsMiwnrIVxA59AQ==
Message-Id: <20080223232618.763703000@menage.corp.google.com>
References: <20080223224725.115590000@menage.corp.google.com>
User-Agent: quilt/0.45-1
Date: Sat, 23 Feb 2008 14:47:35 -0800
From: menage@google.com
To: akpm@linux-foundation.org, balbir@in.ibm.com, pj@sgi.com,
       Pavel Emelianov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: [PATCH 10/10] CGroup API files: Make CGROUP_DEBUG default to off
Content-Disposition: inline; filename=default_off_cgroup_debug.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cgroup debug subsystem isn't generally useful for users. It should default to "n".

Signed-off-by: Paul Menage <menage@google.com>

---
 init/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: cgroup-2.6.25-rc2-mm1/init/Kconfig
===================================================================
--- cgroup-2.6.25-rc2-mm1.orig/init/Kconfig
+++ cgroup-2.6.25-rc2-mm1/init/Kconfig
@@ -284,6 +284,7 @@ config CGROUPS
 config CGROUP_DEBUG
 	bool "Example debug cgroup subsystem"
 	depends on CGROUPS
+	default n
 	help
 	  This option enables a simple cgroup subsystem that
 	  exports useful debugging information about the cgroups

--
