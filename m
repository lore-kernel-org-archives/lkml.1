Return-Path: <linux-kernel-owner+w=401wt.eu-S1758556AbZFZRam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556AbZFZRam (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 13:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbZFZRaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 13:30:35 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57959 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbZFZRae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 13:30:34 -0400
Date: Fri, 26 Jun 2009 13:30:26 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, earl_chew@agilent.com,
       Oleg Nesterov <oleg@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] exec: Make do_coredump more robust and safer when
	using pipes in core_pattern
Message-ID: <20090626173026.GB7337@hmsreliant.think-freely.org>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <20090625163050.d6a71a13.akpm@linux-foundation.org> <20090626104804.GA7337@hmsreliant.think-freely.org> <20090626092001.32e35e17.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090626092001.32e35e17.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26, 2009 at 09:20:01AM -0700, Andrew Morton wrote:
> On Fri, 26 Jun 2009 06:48:04 -0400 Neil Horman <nhorman@tuxdriver.com> wrote:
> 
> > > > --- a/kernel/sysctl.c
> > > > +++ b/kernel/sysctl.c
> > > > @@ -75,6 +75,7 @@ extern int max_threads;
> > > >  extern int core_uses_pid;
> > > >  extern int suid_dumpable;
> > > >  extern char core_pattern[];
> > > > +extern unsigned int core_pipe_limit;
> > > 
> > > Bah.
> > > 
> > > We should fix this one day.
> > > 
> > Is there a particular way you'd like to see it fixed?
> 
> Not in the context of this patch.
> 
> One way would be to add a new sysctl-externs.h and then put all the
> declarations in there.  That file gets included by sysctl.c and by each
> file which shares a global with sysctl.c
> 
Thanks, I'll keep that in mind, and look into squaring it away when I have a few
extra cycles.
Neil

> 
> 
