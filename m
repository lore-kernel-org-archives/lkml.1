Return-Path: <linux-kernel-owner+w=401wt.eu-S1755412AbZCTIZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbZCTIZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 04:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754030AbZCTIZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 04:25:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:55359 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654AbZCTIZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 04:25:15 -0400
Subject: Re: [PATCH 1/1] introduce user_ns inheritance in user-sched
From: Peter Zijlstra <peterz@infradead.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, mingo@elte.hu,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Linux Containers <containers@lists.osdl.org>
In-Reply-To: <20090319211615.GA18383@us.ibm.com>
References: <20090319211615.GA18383@us.ibm.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 20 Mar 2009 09:24:20 +0100
Message-Id: <1237537460.24626.32.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-19 at 16:16 -0500, Serge E. Hallyn wrote:
> In a kernel compiled with CONFIG_USER_SCHED=y, cpu shares are
> allocated according to uid.  Shares are specifiable under
> /sys/kernel/uids/<uid>/
> 
> In a kernel compiled with CONFIG_USER_NS=y, clone(2) with the
> CLONE_NEWUSER flag creates a new user namespace, and the newly
> cloned task will belong to uid 0 in the new user namespace.

We seem to be adding more and more stuff for USER_SCHED, is anybody
actually using that cruft?

How far along with cgroups are we to fully simulate that behaviour?

I think if we have a capable cgroup based replacement for USER_SCHED we
should axe it from the kernel, would save lots of code...


