Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbZGCOow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbZGCOow (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 10:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbZGCOoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 10:44:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56514 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbZGCOon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 10:44:43 -0400
Date: Fri, 3 Jul 2009 11:36:36 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Robert Richter <robert.richter@amd.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, Anton Blanchard <anton@samba.org>,
       Sam Ravnborg <sam@ravnborg.org>, Peter Zijlstra <peterz@infradead.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf tools: gitignore *.data
Message-ID: <20090703143636.GH7240@ghostprotocols.net>
References: <1246603147.2322.3.camel@jaswinder.satnam> <20090703103852.GA3242@elte.hu> <20090703130936.GA5072@nowhere> <20090703131824.GB3207@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090703131824.GB3207@elte.hu>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jul 03, 2009 at 03:18:24PM +0200, Ingo Molnar escreveu:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Fri, Jul 03, 2009 at 12:38:52PM +0200, Ingo Molnar wrote:
> > > 
> > > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > > 
> > > > perf.data made by perf record is a data file and need to be 
> > > > ignored by git
> > > > 
> > > > Added *.data so that perf.data and its friends will be ignored.
> > > 
> > > >  cscope*
> > > > +*.data
> > > 
> > > ok, this is something i wanted to revisit eventually - the 
> > > 'perf.data' name sucks a bit - as .data postfix is quite unspecific.
> > > 
> > > Perhaps trace.perf is a better default name, and all files would 
> > > have the .perf postfix?
> > > 
> > > I've Cc:-ed a number of folks who might have an opinion about this - 
> > > what would be the best default naming and postfix for perf binary 
> > > files?
> > > 
> > > 	Ingo
> > 
> > perf.bin seems to me adequate as it tells everything (IMHO).
> 
> hm, .bin is pretty overloaded as well. It also suggests a 
> 'executable binary' in a certain way - which it isnt.

.samples
.perf
.perf_samples
.ps - oops, also used ;-)

- Arnaldo
