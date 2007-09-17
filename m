Return-Path: <linux-kernel-owner+w=401wt.eu-S932257AbXIQVLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257AbXIQVLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 17:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760245AbXIQVHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 17:07:32 -0400
Received: from smtp-out.google.com ([216.239.45.13]:52106 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760288AbXIQVH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 17:07:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:references:user-agent:date:from:to:cc:
	subject:content-disposition;
	b=qA0r9j4lA3LfU87MdWXsJJSadHQmB/xlqvlWDRBJ83zgr4GmV+Am8+EVVRQoHul9g
	8qc5cfdApsYxt7wOwVgCQ==
Message-Id: <20070917210428.871858000@menage.corp.google.com>
References: <20070917210307.116234000@menage.corp.google.com>
User-Agent: quilt/0.45-1
Date: Mon, 17 Sep 2007 14:03:24 -0700
From: Paul Menage <menage@google.com>
To: akpm@linuxfoundation.org, balbir@linux.vnet.ibm.com,
       "Serge E. Hallyn" <serue@us.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelianov <xemul@openvz.org>,
       David Rientjes <rientjes@google.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, pj@sgi.com,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 17/33] add containerstats v3 fix
Content-Disposition: inline; filename=add-containerstats-v3-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
(container->cgroup renaming by Paul Menage <menage@google.com>)

kernel/taskstats.c: In function 'cgroupstats_user_cmd':
kernel/taskstats.c:414: error: dereferencing pointer to incomplete type

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/taskstats.c~add-cgroupstats-v3-fix kernel/taskstats.c
--- a/kernel/taskstats.c~add-cgroupstats-v3-fix
+++ a/kernel/taskstats.c
@@ -24,6 +24,7 @@
 #include <linux/percpu.h>
 #include <linux/cgroupstats.h>
 #include <linux/cgroup.h>
+#include <linux/fs.h>
 #include <linux/file.h>
 #include <net/genetlink.h>
 #include <asm/atomic.h>
_

--
