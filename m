Return-Path: <linux-kernel-owner+w=401wt.eu-S1760509AbXIQVIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760509AbXIQVIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 17:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760259AbXIQVG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 17:06:59 -0400
Received: from smtp-out.google.com ([216.239.33.17]:9171 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760246AbXIQVG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 17:06:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:references:user-agent:date:from:to:cc:
	subject:content-disposition;
	b=oyzGLFscvUbdTWWcztKfzOLVSZZK8L0BvTLkY+5/yalTupj63Y9qYSBhjk8jTD3sj
	qZQirGCfigOy/8iVTgnZA==
Message-Id: <20070917210430.675805000@menage.corp.google.com>
References: <20070917210307.116234000@menage.corp.google.com>
User-Agent: quilt/0.45-1
Date: Mon, 17 Sep 2007 14:03:35 -0700
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
Subject: [PATCH 28/33] memory controller add per container lru and reclaim v7 fix
Content-Disposition: inline; filename=memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
(container->cgroup renaming by Paul Menage <menage@google.com>)

mm/memcontrol.c: In function 'mem_cgroup_charge':
mm/memcontrol.c:337: error: implicit declaration of function 'congestion_wait'

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Paul Menage <menage@google.com>
---

 mm/memcontrol.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/memcontrol.c~memory-controller-add-per-cgroup-lru-and-reclaim-v7-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memory-controller-add-per-cgroup-lru-and-reclaim-v7-fix
+++ a/mm/memcontrol.c
@@ -22,6 +22,7 @@
 #include <linux/cgroup.h>
 #include <linux/mm.h>
 #include <linux/page-flags.h>
+#include <linux/backing-dev.h>
 #include <linux/bit_spinlock.h>
 #include <linux/rcupdate.h>
 #include <linux/swap.h>
_

--
