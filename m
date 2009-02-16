Return-Path: <linux-kernel-owner+w=401wt.eu-S1756746AbZBPQng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746AbZBPQng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 11:43:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbZBPQmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 11:42:15 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49939 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334AbZBPQmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 11:42:12 -0500
Message-Id: <20090216163847.431174825@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 16 Feb 2009 17:38:47 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/4] generic smp helpers vs kmalloc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve's recent patches brought up the need (or rather, lack thereof) of the
kmalloc() usage in smp_call_function_single().

This patch set does the same for the multi-cpu case and fully removes kmalloc.

Tested on a Q9450 with a kernel build.

