Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbZJ0Q2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbZJ0Q2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 12:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755810AbZJ0Q2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 12:28:36 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:47533 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755767AbZJ0Q2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 12:28:35 -0400
Date: Tue, 27 Oct 2009 16:28:03 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jeff Mahoney <jeffm@suse.com>,
       Jiri Kosina <jkosina@suse.cz>, "Luck, Tony" <tony.luck@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [Bug #14467] Linker errors on ia64 with NR_CPUS=4096
In-Reply-To: <6dRYo8ss7vL.A.nnF.Cre5KB@chimera>
Message-ID: <alpine.DEB.1.10.0910271623210.20363@V090114053VZO-1>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <6dRYo8ss7vL.A.nnF.Cre5KB@chimera>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NR_CPUS array in the percpu section needs to be removed.

A simple fix would be to allocate the rq_weight per cpu array
dynamically.

The large per cpu array was introduced as a fix to a race condition. Maybe
there is another way of dealing with this issue that does not require
large per cpu arrays?



