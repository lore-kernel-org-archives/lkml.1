Return-Path: <linux-kernel-owner+w=401wt.eu-S1754379AbZIOHvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379AbZIOHvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 03:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbZIOHu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 03:50:58 -0400
Received: from brick.kernel.dk ([93.163.65.50]:41635 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbZIOHu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 03:50:58 -0400
Date: Tue, 15 Sep 2009 09:51:00 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Eric Paris <eparis@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       James Morris <jmorris@namei.org>, Thomas Liu <tliu@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [origin tree SLAB corruption #2] BUG kmalloc-64: Poison
	overwritten, INFO: Allocated in bdi_alloc_work+0x2b/0x100 age=175
	cpu=1 pid=3514
Message-ID: <20090915075100.GB23126@kernel.dk>
References: <1252808939.13780.30.camel@dhcp231-106.rdu.redhat.com> <20090914071631.GA24801@elte.hu> <alpine.LFD.2.01.0909140725470.3654@localhost.localdomain> <20090914162902.GF6773@linux.vnet.ibm.com> <20090914171037.GG14984@kernel.dk> <20090915065707.GA3435@elte.hu> <20090915071158.GA31392@elte.hu> <20090915072433.GS14984@kernel.dk> <20090915074425.GA13689@elte.hu> <20090915074802.GA21895@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915074802.GA21895@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15 2009, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > trying to pull in:
> > > 
> > >   git://git.kernel.dk/linux-2.6-block.git writeback
> > > 
> > > and see if it reproduces there? That path has been cleaned up 
> > > considerably there.
> > 
> > I gave it a test-pull - and the bug does not trigger anymore.
> > 
> > Note, that may not mean much: your tree is based on a fresh upstream 
> > tree so it pulled a lot of new stuff into -tip that i have yet to 
> > test/validate. It also changed the kernel image size/layout 
> > considerably and this bug seems to be a very narrow to hit race of 
> > sorts.
> 
> Btw., is there anything in your cleanups that could explain this bug? 
> Some list handling bug? A double free? Uninitialized memory? Race 
> between block IRQs and process context?

No that that I noticed, it was just a thought since that path has been
cleaned up and I have been looking at the newer tree only. I'll take a
good look at the current -git situation.

-- 
Jens Axboe

