Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbZGJJig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbZGJJig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 05:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbZGJJi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 05:38:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36659 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376AbZGJJi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 05:38:26 -0400
Date: Fri, 10 Jul 2009 11:38:25 +0200
From: Nick Piggin <npiggin@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Janboe Ye <yuan-bo.ye@motorola.com>, linux-kernel@vger.kernel.org,
       vegard.nossum@gmail.com, graydon@redhat.com, fche@redhat.com,
       cl@linux-foundation.org
Subject: Re: [RFC][PATCH] Check write to slab memory which freed already using mudflap
Message-ID: <20090710093825.GJ14666@wotan.suse.de>
References: <1247156020.27671.40.camel@debian-nb> <84144f020907090944u51f60cbsc0a4ec2c2cbdcc8c@mail.gmail.com> <20090710084745.GA26752@elte.hu> <alpine.DEB.2.00.0907100158090.13880@chino.kir.corp.google.com> <1247217548.771.10.camel@penberg-laptop> <alpine.DEB.2.00.0907100223140.14601@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0907100223140.14601@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 10, 2009 at 02:31:43AM -0700, David Rientjes wrote:
> On Fri, 10 Jul 2009, Pekka Enberg wrote:
> 
> > > I'm not sure what the status of slqb is, although I would have expected it 
> > > to have been pushed for inclusion in 2.6.31 as a slab allocator 
> > > alternative.  Nick, any forecast for inclusion?
> > 
> > 2.6.32 most likely. Nick has fixed a bunch of problems but there's still
> > one ppc boot time bug that's turning out to be hard to find.
> > 
> 
> Ah, ok, there's still outstanding bugs.  I was curious as to why it wasn't 
> merged as a non-default option that would have perhaps attracted more 
> attention to it.

Don't know whether it should go in as non-default or not. The plan
is to kind of kick up a stink and make people care about the slab
issue again rather than quietly add more slab allocators to the
tree...

Perhaps making it non-default for one release would be a good idea,
I don't know.

