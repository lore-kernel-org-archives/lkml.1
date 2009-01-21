Return-Path: <linux-kernel-owner+w=401wt.eu-S1753740AbZAUT5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbZAUT5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 14:57:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbZAUT4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 14:56:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36647 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbZAUT4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 14:56:53 -0500
Date: Wed, 21 Jan 2009 20:56:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>
Subject: Re: [announce] Performance Counters for Linux, v6
Message-ID: <20090121195623.GA31013@elte.hu>
References: <20090121185021.GA8852@elte.hu> <497778E3.1020502@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497778E3.1020502@oracle.com>
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
> > We are pleased to announce version 6 of our performance counters subsystem 
> > implementation. The shortlog, diffstat and the combo patch can be found 
> > below. The combo patch against latest -git (2.6.29-rc2) can be also found 
> > at:
> > 
> >    http://people.redhat.com/mingo/perfcounters/perfcounters-v6-v2.6.29-rc2.patch
> > 
> > It's also available in tip/master at:
> >  
> >    http://people.redhat.com/mingo/tip.git/README
> >  
> > There are many changes in the v6 release:
> > 
> >  - PowerPC performance counters support from Paul Mackerras, for POWER6
> >    and for the PPC970 family.
> > 
> >  - ioctl API to disable/enable individual counters and groups without
> >    closing their fd. This can be useful for libraries, ad-hoc 
> >    instrumentation and PAPI support.
> > 
> >  - 'pinned' and 'exclusive' counter attributes - for those
> >    applications that want to influence counter scheduling explicitly.
> > 
> >  - The 'perfstat' utility (ex 'timec') has been updated:
> > 
> >       http://people.redhat.com/mingo/perfcounters/perfstat.c
> > 
> >  - 'kerneltop' (easy-to-use text mode NMI profiler) has been updated:
> >    
> >       http://people.redhat.com/mingo/perfcounters/kerneltop.c
> 
> BTW, this kerneltop has nothing to do with that other one??
> 
> 	http://www.xenotime.net/linux/kerneltop/

heh, didnt know about that one - there's no connection other than the name 
:-) The project seems somewhat stale but indeed similar in purpose. Can
rename to kerneltop2 i guess.

	Ingo
