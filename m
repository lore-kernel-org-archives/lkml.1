Return-Path: <linux-kernel-owner+w=401wt.eu-S1756855AbZBSAA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855AbZBSAA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 19:00:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbZBSAAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 19:00:14 -0500
Received: from gw.goop.org ([64.81.55.164]:51152 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985AbZBSAAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 19:00:13 -0500
Message-ID: <499CA106.8020104@goop.org>
Date: Wed, 18 Feb 2009 16:00:06 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/4] generic-smp: remove kmalloc usage
References: <20090216163847.431174825@chello.nl> <1234859071.4744.10.camel@laptop> <20090217094359.GA1231@elte.hu> <200902181520.17504.rusty@rustcorp.com.au> <20090218160535.GD23989@elte.hu>
In-Reply-To: <20090218160535.GD23989@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> The kmalloc(GFP_ATOMIC) has been in kernel/smp.c for about half 
> a year, since:
>
>  |  commit 3d4422332711ef48ef0f132f1fcbfcbd56c7f3d1
>  |  Author: Jens Axboe <jens.axboe@oracle.com>
>  |  Date:   Thu Jun 26 11:21:34 2008 +0200
>  |  Subject: [PATCH] Add generic helpers for arch IPI function calls
>
> Which introduced kernel/smp.c to begin with. It got merged on 
> July 15.
>   

The kmalloc to resolve the stack lifetime vs rcu bug is more recent than 
that - around August, I think.

    J
