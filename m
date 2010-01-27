Return-Path: <linux-kernel-owner+w=401wt.eu-S1753748Ab0A0AUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab0A0AUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:20:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753503Ab0A0AUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:20:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45854 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751953Ab0A0AUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 19:20:21 -0500
Date: Tue, 26 Jan 2010 16:19:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, rientjes@google.com,
       minchan.kim@gmail.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH v3] oom-kill: add lowmem usage aware oom kill handling
Message-Id: <20100126161952.ee267d1c.akpm@linux-foundation.org>
In-Reply-To: <20100127085355.f5306e78.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100121145905.84a362bb.kamezawa.hiroyu@jp.fujitsu.com>
	<20100122152332.750f50d9.kamezawa.hiroyu@jp.fujitsu.com>
	<20100125151503.49060e74.kamezawa.hiroyu@jp.fujitsu.com>
	<20100126151202.75bd9347.akpm@linux-foundation.org>
	<20100127085355.f5306e78.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jan 2010 08:53:55 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> > Hardly anyone will know to enable
> > it so the feature won't get much testing and this binary decision
> > fractures the testing effort.  It would be much better if we can get
> > everyone running the same code.  I mean, if there are certain workloads
> > on certain machines with which the oom-killer doesn't behave correctly
> > then fix it!
> Yes, I think you're right. But "breaking current behaviro of our servers!"
> arguments kills all proposal to this area and this oom-killer or vmscan is
> a feature should be tested by real users. (I'll write fork-bomb detector
> and RSS based OOM again.)

Well don't break their servers then ;)

What I'm not understanding is: why is it not possible to improve the
behaviour on the affected machines without affecting the behaviour on
other machines?

What are these "servers" to which you refer?  x86_32 servers, I assume
- the patch shouldn't affect 64-bit machines.  Why don't they also want
this treatment and in what way does the patch "break" them?

