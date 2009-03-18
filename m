Return-Path: <linux-kernel-owner+w=401wt.eu-S1757171AbZCRQuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171AbZCRQuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 12:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758288AbZCRQtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 12:49:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48296 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758672AbZCRQtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 12:49:46 -0400
Date: Wed, 18 Mar 2009 17:49:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Steven Rostedt <srostedt@redhat.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: linux-next: Tree for March 11 (tracing)
Message-ID: <20090318164926.GC31315@elte.hu>
References: <20090311225913.51589223.sfr@canb.auug.org.au> <49B7F691.5000305@oracle.com> <49B93584.3020302@oracle.com> <1236875181.11290.1.camel@localhost.localdomain> <20090318084651.3dbf01e3.randy.dunlap@oracle.com> <20090318160621.GA21331@elte.hu> <49C11DB4.3070500@oracle.com> <20090318163228.GD21331@elte.hu> <49C124DE.9090001@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C124DE.9090001@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> Ingo Molnar wrote:
> > * Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > 
> >> Ingo Molnar wrote:
> >>> * Randy Dunlap <randy.dunlap@oracle.com> wrote:
> >>>
> >>>> On Thu, 12 Mar 2009 12:26:21 -0400 Steven Rostedt wrote:
> >>>>
> >>>>> On Thu, 2009-03-12 at 09:17 -0700, Randy Dunlap wrote:
> >>>>>> [adding cc:s]
> >>>>>>
> >>>>>> [same report for March 12]
> >>>>>>
> >>>>>> Randy Dunlap wrote:
> >>>>>>> Stephen Rothwell wrote:
> >>>>>>>> Hi all,
> >>>>>>>>
> >>>>>>>> Changes since 20090310:
> >>>>>>> Building on i386 generates a ton of printk format warnings:
> >>>>>>>
> >>>>>>> kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'unsigned int'
> >>>>>>> kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 6 has type 'unsigned int'
> >>>>>>> kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 9 has type 'unsigned int'
> >>>>>>> kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 10 has type 'unsigned int'
> >>>>>>> kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 13 has type 'unsigned int'
> >>>>>>> kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 14 has type 'unsigned int'
> >>>>>>> kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 17 has type 'unsigned int'
> >>>>>>> kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 18 has type 'unsigned int'
> >>>>>>> kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 21 has type 'unsigned int'
> >>>>>>> kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 22 has type 'unsigned int'
> >>>>>>>
> >>>>> I believe this is corrected in Ingo's tip tree. I changed %lu to %zu to
> >>>>> handle the "sizeof()" case. The fix was suggested by Andrew Morton.
> >>>> This build warning is still around (20090318).
> >>>> Is the fix not in some branch that is imported into linux-next or what?
> >>> be patient.
> >>>
> >>> 	Ingo
> >> I think that 7 days is being patient for a simple build fix.
> > 
> > s/build fix/harmless build warning fix
> 
> 180+ lines of noise in a build log.
> 
> > If you are interested in having a resolution you can git-merge the 
> > latest development tree yourself and you can get rid of that 
> > warning.
> > 
> > Of course that way you'd expose yourself to even fresher code, 
> > potentially with much more serious breakages.
> > 
> > It's a balance of freshness versus stability, and that balance is 
> > kept by maintainers.
> > 
> > If you want the latest development code - go engage with the 
> > development trees directly.
> > 
> > If you want something that is relatively new (i.e. 1-2 weeks fresh) 
> > but works on the range of systems we test, use what you get in 
> > linux-next.
> > 
> > It's your choice which one you pick.
> > 
> > But you cannot have both.
> > 
> > If you genuinely think you can have it both, by all means i 
> > encourage you to try it - it's all open source so you can run your 
> > own tree. Just please dont feel entitled to demand it from others.
> 
> Thanks for the explanation.  That's what I tried to ask for
> to begin with.  I guess that I have a language problem.

Note, six hours ago i reintegrated all the auto-next branches so 
this warning should be gone in the next linux-next iteration - they 
are now traded for brand new bugs ;-)

	Ingo
