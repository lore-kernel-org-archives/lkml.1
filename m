Return-Path: <linux-kernel-owner+w=401wt.eu-S1757325AbXJCFWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325AbXJCFWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 01:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbXJCFWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 01:22:01 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:45530 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751438AbXJCFWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 01:22:00 -0400
Date: Tue, 2 Oct 2007 22:21:58 -0700
From: Paul Jackson <pj@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: wibbling over the cpuset shed domain connnection
Message-Id: <20071002222158.1a083348.pj@sgi.com>
In-Reply-To: <200710022236.59583.nickpiggin@yahoo.com.au>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
	<20071001143443.b873f70d.pj@sgi.com>
	<200710022236.59583.nickpiggin@yahoo.com.au>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> In the meantime, that patch should be merged though, shouldn't it?

Which patch do you refer to:
 1) the year old patch to disconnect cpusets and sched domains:
	cpuset-remove-sched-domain-hooks-from-cpusets.patch
 2) my patch of a few days ago to add a 'sched_load_balance' flag:
	cpuset and sched domains: sched_load_balance flag

I can't push one without the other, because some real time folks are
depending on the sched domain hooks that (1) would remove, so need some
alternative, such as in (2).  Even though (1) is rather broken, as you
note, it still provides a way that the real time folks can disable load
balancing at runtime on selected CPUs, so is essential to their work.

I can't delay any more resolving this, because the cgroup (aka
container) code is tangled up with (1), and Andrew needs a clear path
to send cgroups to Linus real soon now.

In my last message to you, a couple of days ago, I asked what I thought
were a couple of key and simple questions -- can sched domains overlap,
and what does it mean for user space if they overlap?  A further
question comes to mind now -- if sched domains can overlap, does this
provide some capability to user space that is important to provide?

Could you take a minute, Nick, to consider these questions?  Thanks.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
