Return-Path: <linux-kernel-owner+w=401wt.eu-S1758132AbYLPTwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132AbYLPTwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:52:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754827AbYLPTwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:52:17 -0500
Received: from ns.suse.de ([195.135.220.2]:49660 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754206AbYLPTwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:52:16 -0500
Date: Tue, 16 Dec 2008 11:51:05 -0800
From: Greg KH <gregkh@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Fabio Comolli <fabio.comolli@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [Bug #12155] Regression in 2.6.28-rc and 2.6.27-stable -
	hibernate related
Message-ID: <20081216195105.GA7791@suse.de>
References: <u7kfEgp36eE.A.qpG.Y4_QJB@chimera> <T1gm2CtAHBF.A.bnH.14_QJB@chimera> <b637ec0b0812131045n34bf420w3729abf24533b51c@mail.gmail.com> <200812131956.03495.rjw@sisk.pl> <20081216190707.GA336@elte.hu> <alpine.LFD.2.00.0812161113350.14014@localhost.localdomain> <20081216191827.GA1176@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081216191827.GA1176@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 08:18:27PM +0100, Ingo Molnar wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Tue, 16 Dec 2008, Ingo Molnar wrote:
> > > 
> > > yeah - i think it's too late to do anything but a revert here.
> > 
> > Yup. Already done. Commit ca7e716c7833aeaeb8fedd6d004c5f5d5e14d325.
> > 
> > Did -stable revert it too?
> 
> not that i know of (-stable tries to follow upstream with reverts too).
> We could have put a Cc: stable@kernel.org into the reverter commit ;-)

Yes, I'll go revert it later today, give me a chance to catch up :)

thanks,

greg k-h
