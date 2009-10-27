Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbZJ0SYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbZJ0SYD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 14:24:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755339AbZJ0SYC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 14:24:02 -0400
Received: from cantor.suse.de ([195.135.220.2]:38921 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811AbZJ0SYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 14:24:01 -0400
Date: Tue, 27 Oct 2009 19:24:03 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Christoph Lameter <cl@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jeff Mahoney <jeffm@suse.com>,
       "Luck, Tony" <tony.luck@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [Bug #14467] Linker errors on ia64 with NR_CPUS=4096
In-Reply-To: <alpine.DEB.1.10.0910271623210.20363@V090114053VZO-1>
Message-ID: <alpine.LSU.2.00.0910271922490.19847@wotan.suse.de>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <6dRYo8ss7vL.A.nnF.Cre5KB@chimera> <alpine.DEB.1.10.0910271623210.20363@V090114053VZO-1>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009, Christoph Lameter wrote:

> The NR_CPUS array in the percpu section needs to be removed.
> 
> A simple fix would be to allocate the rq_weight per cpu array
> dynamically.

There already are two patches for this acked by Ingo/Tejun, which Tejun is 
going to take through his tree tomorrow.

	http://lkml.org/lkml/2009/10/27/132
	http://lkml.org/lkml/2009/10/27/215

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
