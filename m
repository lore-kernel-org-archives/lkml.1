Return-Path: <linux-kernel-owner+w=401wt.eu-S1753551AbZIRMlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbZIRMlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 08:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbZIRMlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 08:41:08 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:50712 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752069AbZIRMlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 08:41:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtYEAFwXs0pMROOX/2dsb2JhbACBUswvhBwF
Date: Fri, 18 Sep 2009 08:41:09 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@lst.de>, Steven Rostedt <rostedt@goodmis.org>,
       "Fr?d?ric Weisbecker" <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kill markers
Message-ID: <20090918124109.GE1173@Krystal>
References: <20090917173527.GA1699@lst.de> <20090918102334.GA24638@elte.hu> <20090918121329.GA1173@Krystal> <20090918123846.GB24391@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090918123846.GB24391@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 08:40:34 up 30 days, 23:30,  2 users,  load average: 0.92, 0.52,
	0.30
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > * Ingo Molnar (mingo@elte.hu) wrote:
> > > 
> > > * Christoph Hellwig <hch@lst.de> wrote:
> > > 
> > > > Now that the last users of markers have migrated to the event tracer 
> > > > we can kill off the support code.
> > > 
> > > Applied, thanks Christoph!
> > > 
> > > Btw., there's some more marker related bits in the kernel, such as 
> > > scripts/mod/modpost.c - mostly the effects of:
> > > 
> > >   b2e3e65: Linux Kernel Markers: create modpost file
> > > 
> > > I think we want to keep those bits, for those who want to use new 
> > > modpost with an older kernel - but mark them for deprecation.
> > 
> > Just to confirm: this means having a printk-style infrastructure to 
> > prototype tracepoints is not considered useful ?
> 
> trace_printk()?

OK, sounds good !

No objection then :)

Thanks,

Mathieu

> 
> 	Ingo

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
