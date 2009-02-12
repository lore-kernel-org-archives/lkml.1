Return-Path: <linux-kernel-owner+w=401wt.eu-S1760263AbZBLWka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760263AbZBLWka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 17:40:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbZBLWkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 17:40:19 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54400 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbZBLWkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 17:40:18 -0500
Message-Id: <20090212223200.979433820@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 12 Feb 2009 23:32:00 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/2] generic smp helpers vs kmalloc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve's recent patches brought up the need (or rather, lack thereof) of the
kmalloc() usage in smp_call_function_single().

The first patch, removes the need for kmalloc() for smp_call_function() too.
The second patch then fully removes the kmalloc() usage.

Patches have been compile and boot tested on a dual core -- so no real
stress testing.
-- 

