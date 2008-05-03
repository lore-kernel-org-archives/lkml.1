Return-Path: <linux-kernel-owner+w=401wt.eu-S1762290AbYECLJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762290AbYECLJU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 07:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755233AbYECLJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 07:09:10 -0400
Received: from relay1.sgi.com ([192.48.171.29]:56119 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755198AbYECLJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 07:09:08 -0400
Date: Sat, 3 May 2008 06:09:04 -0500
From: Jack Steiner <steiner@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Robin Holt <holt@sgi.com>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>, Chris Wright <chrisw@redhat.com>,
       Marcelo Tosatti <marcelo@kvack.org>, Eric Dumazet <dada1@cosmosbay.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH 00 of 11] mmu notifier #v15
Message-ID: <20080503110904.GA19688@sgi.com>
References: <patchbomb.1209740703@duo.random>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <patchbomb.1209740703@duo.random>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 05:05:03PM +0200, Andrea Arcangeli wrote:
> Hello everyone,
> 
> 1/11 is the latest version of the mmu-notifier-core patch.
> 
> As usual all later 2-11/11 patches follows but those aren't meant for 2.6.26.
> 

Not sure why -mm is different, but I get compile errors w/o the following...

--- jack


Index: linux/mm/mmu_notifier.c
===================================================================
--- linux.orig/mm/mmu_notifier.c	2008-05-02 16:54:52.780576831 -0500
+++ linux/mm/mmu_notifier.c	2008-05-02 16:56:38.817719509 -0500
@@ -16,6 +16,7 @@
 #include <linux/srcu.h>
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
+#include <linux/rculist.h>
 
 /*
  * This function can't run concurrently against mmu_notifier_register
