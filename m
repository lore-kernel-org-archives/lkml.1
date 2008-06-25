Return-Path: <linux-kernel-owner+w=401wt.eu-S1757779AbYFYF3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779AbYFYF3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 01:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753817AbYFYF3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 01:29:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:33677 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbYFYF3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 01:29:42 -0400
Subject: Re: [PATCH 6/6] futex: fix miss ordered wakeups
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080624232020.505470899@mvista.com>
References: <20080624232018.817822790@mvista.com>
	 <20080624232020.505470899@mvista.com>
Content-Type: text/plain
Date: Wed, 25 Jun 2008 07:29:27 +0200
Message-Id: <1214371767.16881.5.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-24 at 16:20 -0700, Daniel Walker wrote:
> plain text document attachment (blocked_on-futex.patch)
> Adds an additional function call to the sched_setscheduler to update the
> waiter position of a task if it happens to be waiting on a futex. This
> ensures that the kernel level waiter ordering is correctly maintained
> based on the changed priority of the task.
> 
> I fixed the locking issue noticed by Thomas Gleixner.
> 
> This doesn't address userspace at all, only the kernel level wakeups and
> kernel level ordering.
> 
> The additional locking added to the futex_wait function has no visible speed
> impact, and only effects waiters which actual enter the kernel.


Daniel, I'm not sure what to think,.. you were told how broken this
approach was, you were told to give proper justification for this
change. You did neither and just reposted the same old broken shite
again.

Wake up.

(Just in case you missed it, that's a NAK)

