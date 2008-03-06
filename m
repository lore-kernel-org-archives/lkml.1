Return-Path: <linux-kernel-owner+w=401wt.eu-S1758693AbYCFUGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693AbYCFUGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 15:06:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757959AbYCFUF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 15:05:57 -0500
Received: from smtp-out.google.com ([216.239.33.17]:32050 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763460AbYCFUFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 15:05:39 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=igcFXYeYRB1HH3MSaIq75ouOiOGcF/gQZUiwplAVmvkE32WjBSbD8eopSO2nkVb7c
	sDDC3mqBVABfP9M1VY2Mg==
Date: Thu, 6 Mar 2008 12:05:07 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Paul Jackson <pj@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: [patch -mm 4/4] mempolicy: remove includes for duplicate headers
In-Reply-To: <alpine.DEB.1.00.0803061136160.18590@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.00.0803061136320.18590@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0803061135001.18590@chino.kir.corp.google.com> <alpine.DEB.1.00.0803061135560.18590@chino.kir.corp.google.com> <alpine.DEB.1.00.0803061136160.18590@chino.kir.corp.google.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove #includes for:

	linux/mempolicy.h	(already from linux/migrate.h)
	linux/mm.h		(already from linux/highmem.h)
	linux/kernel.h		(already from linux/nodemask.h)
	linux/nodemask.h	(already from linux/sched.h)
	linux/gfp.h		(already from linux/slab.h)
	linux/slab.h		(already from linux/mempolicy.h)
	linux/init.h		(already from linux/mmzone.h)

Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/mempolicy.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -65,21 +65,14 @@
    kernel is not always grateful with that.
 */
 
-#include <linux/mempolicy.h>
-#include <linux/mm.h>
 #include <linux/highmem.h>
 #include <linux/hugetlb.h>
-#include <linux/kernel.h>
 #include <linux/sched.h>
-#include <linux/nodemask.h>
 #include <linux/cpuset.h>
-#include <linux/gfp.h>
-#include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/module.h>
 #include <linux/nsproxy.h>
 #include <linux/interrupt.h>
-#include <linux/init.h>
 #include <linux/compat.h>
 #include <linux/swap.h>
 #include <linux/seq_file.h>
