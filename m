Return-Path: <linux-kernel-owner+w=401wt.eu-S1754734AbZGVTuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbZGVTuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 15:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754510AbZGVTuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 15:50:37 -0400
Received: from smtp-out.google.com ([216.239.45.13]:28204 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484AbZGVTue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 15:50:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=SYWs01+bi0kW/AKk1XDudamdkZ21TR1BVgVgi82lduFaK+zXK9D6gxu9gxr3TT4Sk
	DrJqVvHGtTU189Eunn9+Q==
From: Paul Menage <menage@google.com>
Subject: [PATCH 0/4] CGroup: Support for named and empty hierarchies
To: akpm@linux-foundation.org, lizf@cn.fujitsu.com
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Date: Wed, 22 Jul 2009 12:50:24 -0700
Message-ID: <20090722194644.7481.47805.stgit@menage.mtv.corp.google.com>
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

This is a subset of the patch series that I sent out as an RFC earlier
in the month; I'm not pushing the additional support for
multiply-bound hierarchies at this point.

Signed-off-by: Paul Menage <menage@google.com>

---

Paul Menage (4):
      Support named cgroups hierarchies
      Move the cgroup debug subsys into cgroup.c to access internal state
      Add a back-pointer from struct cg_cgroup_link to struct cgroup
      Allow cgroup hierarchies to be created with no bound subsystems


 Documentation/cgroups/cgroups.txt |   19 +
 kernel/Makefile                   |    1 
 kernel/cgroup.c                   |  660 +++++++++++++++++++++++++++++--------
 kernel/cgroup_debug.c             |  105 ------
 4 files changed, 533 insertions(+), 252 deletions(-)
 delete mode 100644 kernel/cgroup_debug.c

