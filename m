Return-Path: <linux-kernel-owner+w=401wt.eu-S1757228AbZGCNGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228AbZGCNGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 09:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbZGCNF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 09:05:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39615 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389AbZGCNF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 09:05:59 -0400
Subject: Re: ring-buffer: Kernel threads cpu utilization.
From: Steven Rostedt <srostedt@redhat.com>
To: Tej <bewith.tej@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <f1c9d250907022306j4ea1eb3g47101bd4a9528f61@mail.gmail.com>
References: <f1c9d250907022306j4ea1eb3g47101bd4a9528f61@mail.gmail.com>
Content-Type: text/plain
Organization: Red Hat
Date: Fri, 03 Jul 2009 09:06:00 -0400
Message-Id: <1246626360.21331.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2009-07-03 at 11:36 +0530, Tej wrote:
> rb_producer and rb_comsumer, kernel thread uses lot of CPU (~100%)
> bandwidth every 10s.
> 
> bisection results commit:
> [5092dbc96f3acdac5433b27c06860352dc6d23b9] ring-buffer: add benchmark and tester
> I have read commit logs:
> git log -r 5092dbc96f3acdac5433b27c06860352dc6d23b9
> 
> Is it correct behavior for these thread to consume this much cpu
> bandwidth even if someone selects rb benchmarks config options?

Yes, that's a benchmark module, not something to be running on a
production system. It consumes a lot of CPU time, because it is running
a constant benchmark, and tests.

-- Steve


