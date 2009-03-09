Return-Path: <linux-kernel-owner+w=401wt.eu-S1751728AbZCINQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbZCINQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 09:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbZCINQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 09:16:10 -0400
Received: from mail.gmx.net ([213.165.64.20]:42457 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751022AbZCINQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 09:16:10 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/hkwZQ7Ufhx4RYIe1RE2wpObjFNJgkAaUE0u5oTZ
	R8viSmZAXuZXnx
Subject: Re: [patch] Re: scheduler oddity [bug?]
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Balazs Scheidler <bazsi@balabit.hu>,
       linux-kernel@vger.kernel.org, Willy Tarreau <w@1wt.eu>
In-Reply-To: <1236596664.8389.331.camel@laptop>
References: <1236448069.16726.21.camel@bzorp.balabit>
	 <1236505323.6281.57.camel@marge.simson.net>
	 <1236506309.6972.8.camel@marge.simson.net> <20090308153956.GB19658@elte.hu>
	 <1236529200.7110.16.camel@marge.simson.net>
	 <20090308175255.GA22802@elte.hu>
	 <1236585731.6118.24.camel@marge.simson.net>
	 <20090309080714.GB24904@elte.hu>  <1236596664.8389.331.camel@laptop>
Content-Type: text/plain
Date: Mon, 09 Mar 2009 14:16:03 +0100
Message-Id: <1236604563.6027.8.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.71
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-09 at 12:04 +0100, Peter Zijlstra wrote:

> OK, talked a bit with Ingo, the reason you're doing is that avg_overlap
> can easily grow stale.. I can see that happen indeed.
> 
> So the 'perfect' thing would be a task-runtime decay, barring that the
> preemption thing seems a sane enough hart-beat of a task.
> 
> How does the below look to you?

Other than the fact that the test for sync reject is currently
avg_overlap > sysctl_sched_migration_cost, looks fine to me.  Having it
capped at the boundary is probably the better way to go.

	-Mike

