Return-Path: <linux-kernel-owner+w=401wt.eu-S1754968Ab0AMTRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab0AMTRc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 14:17:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921Ab0AMTRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 14:17:31 -0500
Received: from tomts16.bellnexxia.net ([209.226.175.4]:54313 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754867Ab0AMTRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 14:17:30 -0500
Date: Wed, 13 Jan 2010 14:17:27 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Nicholas Miell <nmiell@comcast.net>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier (v5)
Message-ID: <20100113191727.GA24742@Krystal>
References: <20100113013757.GA29314@Krystal> <1263358823.3874.10.camel@entropy> <20100113053126.GC6781@linux.vnet.ibm.com> <1263361196.3874.12.camel@entropy> <20100113143805.GC30875@Krystal> <1263406071.3874.16.camel@entropy> <20100113182442.GA20704@Krystal> <1263408098.3874.19.camel@entropy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1263408098.3874.19.camel@entropy>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 14:14:00 up 28 days,  3:32,  4 users,  load average: 0.70, 0.23,
	0.13
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nicholas Miell (nmiell@comcast.net) wrote:
> On Wed, 2010-01-13 at 13:24 -0500, Mathieu Desnoyers wrote:
> > * Nicholas Miell (nmiell@comcast.net) wrote:
> > 
> > > The whole point of compat and incompat flags is that it allows new
> > > applications to run on old kernels and either work or fail as
> > > appropriate, depending on whether the new features they're using must be
> > > implemented or can be silently ignored.
> > 
> > I see. Thanks for the explanation. Then the expedited flag should
> > clearly be part of the mandatory flags.
> > 
> > Can you point me to other system calls that are doing this ?
> > 
> > Thanks,
> > 
> > Mathieu
> 
> Not off the top of my head, but I did steal the idea from the ext2/3/4
> disk format.

Sounds a bit over-engineered to me for system calls, but who knows if we
eventually have to extend sys_membarrier(). This involves that, right
now, I'd have to add a header to include/linux to define these flags.
Also, "int expedited" is a bit clearer, but less flexible, than "int
flags". Anyone else have comments about this ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
