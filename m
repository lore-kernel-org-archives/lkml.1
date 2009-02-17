Return-Path: <linux-kernel-owner+w=401wt.eu-S1752847AbZBQJu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbZBQJu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 04:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbZBQJuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 04:50:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:60811 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbZBQJuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 04:50:14 -0500
Subject: Re: [PATCH 2/4] generic-smp: remove kmalloc usage
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <20090217094359.GA1231@elte.hu>
References: <20090216163847.431174825@chello.nl>
	 <20090216164114.521787803@chello.nl>
	 <alpine.LFD.2.00.0902161636480.21686@localhost.localdomain>
	 <1234859071.4744.10.camel@laptop>  <20090217094359.GA1231@elte.hu>
Content-Type: text/plain
Date: Tue, 17 Feb 2009 10:49:45 +0100
Message-Id: <1234864185.4744.36.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-17 at 10:43 +0100, Ingo Molnar wrote:
> 
> We should not bend backwards trying to preserve that kmalloc() 
> [and prove that it's safe and race-free] - i.e. the burden of 
> proof is on the person insisting that it's needed, not on the 
> person wanting to remove it.

I'm not getting it, I am removing it. The only thing I want to preserve
is the multi-cast ipi and not be forced into the multiple single-ipi
path.

