Return-Path: <linux-kernel-owner+w=401wt.eu-S1758499AbYFEUwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499AbYFEUwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 16:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbYFEUwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 16:52:17 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:21404 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbYFEUwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 16:52:17 -0400
Subject: Re: [patch] sched: prevent bound kthreads from changing
	cpus_allowed
From: Daniel Walker <dwalker@mvista.com>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Paul Menage <menage@google.com>, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0806051255500.31157@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0806051255500.31157@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Thu, 05 Jun 2008 13:52:09 -0700
Message-Id: <1212699129.3319.129.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-06-05 at 12:57 -0700, David Rientjes wrote:
> Kthreads that have called kthread_bind() are bound to specific cpus, so
> other tasks should not be able to change their cpus_allowed from under
> them.  Otherwise, it is possible to move kthreads, such as the migration
> or software watchdog threads, so they are not allowed access to the cpu
> they work on.

I'm all for it .. I've crashed test systems just by migrating tasks that
are suppose to stay bound while using cpusets ..

Daniel

