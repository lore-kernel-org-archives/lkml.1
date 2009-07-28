Return-Path: <linux-kernel-owner+w=401wt.eu-S1751580AbZG1X0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbZG1X0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750961AbZG1X0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:26:40 -0400
Received: from smtp-out.google.com ([216.239.33.17]:39151 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbZG1X0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:26:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=LmmvZhtPcErsQ9EabvaZF46bNsU4bZ93Nf9b1iAZPg4W9BAf7qtDxGJvlpyRwJXgz
	vd7uhf+6arzD0BtbORsyA==
From: Paul Menage <menage@google.com>
Subject: [PATCH 0/4] CGroup: Support for named and empty hierarchies
To: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       kamezawa.hiroyu@jp.fujitsu.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org
Date: Tue, 28 Jul 2009 16:26:16 -0700
Message-ID: <20090728232508.20156.17943.stgit@menage.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series implements support for named cgroup hierarchies,
and for cgroup hierarchies that have no bound subsystems.

Signed-off-by: Paul Menage <menage@google.com>

---

Paul Menage (4):
      Allow cgroup hierarchies to be created with no bound subsystems
      Add a back-pointer from struct cg_cgroup_link to struct cgroup
      Move the cgroup debug subsys into cgroup.c to access internal state
      Support named cgroups hierarchies


 Documentation/cgroups/cgroups.txt |   20 +
 kernel/Makefile                   |    1 
 kernel/cgroup.c                   |  659 +++++++++++++++++++++++++++++--------
 kernel/cgroup_debug.c             |  105 ------
 4 files changed, 533 insertions(+), 252 deletions(-)
 delete mode 100644 kernel/cgroup_debug.c

