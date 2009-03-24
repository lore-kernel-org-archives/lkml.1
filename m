Return-Path: <linux-kernel-owner+w=401wt.eu-S1760500AbZCXSY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760500AbZCXSY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 14:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760239AbZCXSYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 14:24:31 -0400
Received: from relay3.ptmail.sapo.pt ([212.55.154.23]:60001 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1759676AbZCXSY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 14:24:28 -0400
X-AntiVirus: PTMail-AV 0.3-0.92.0
Date: Tue, 24 Mar 2009 18:22:05 +0000
From: Luis Henriques <henrix@sapo.pt>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 -tip] sched: Clean unused fields from struct rq
Message-ID: <20090324182205.GA3930@hades.domain.com>
References: <20090318225137.GA3766@hades.domain.com> <20090323175224.GA3938@hades.domain.com> <20090324140419.GD32043@elte.hu> <49C8FA99.9030503@novell.com> <20090324154130.GC31143@elte.hu> <49C90366.2000905@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C90366.2000905@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Mar 24, 2009 at 11:59:34AM -0400, Gregory Haskins wrote:
> > How about moving schedstat to Documentation/sched/schedstat.c or so? 
> > It's small and trivial enough, and that way changes would go hand in 
> > hand with the app.
> >   
> Oh, I misunderstood.  The tool patch I was referencing is for my
> schedtop tool that is in a separate tree and written in C++.   In
> retrospect, you probably don't care about the relative state of my tool
> coincident with the kernel side change, then.  I agree that this other
> schedstat tool should probably be in-tree and patched at the same time
> as Luis' kernel patch.
> 
> FWIW: I have no problem with schedtop.cc going into the kernel as well
> if that is what you would like, but I figured I would be burned at the
> stake for suggestion such heresy as C++ in the tree ;)

I also agree that there will be issues adding schedtop to the kernel tree, for
two reasons: 1) it is written in C++ 2) it has dependencies on external
libraries (libboost).  So, unless the tool is re-written, I guess it will be
difficult have it accepted.  But that's just me saying this :-)

Now, to summarise and to check I understood everything correctly: I need to
resend my patch (the kernel patch), adding a reference to the URL where
schedtop can be obtained.  Is this correct?  Shall I use the URL to the git
repository or to the rt wiki?  Or both?

-- 
Luis Henriques
