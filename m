Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbZEAX1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbZEAX1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 19:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbZEAX1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 19:27:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49834 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbZEAX1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 19:27:24 -0400
Date: Fri, 1 May 2009 19:27:23 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 0/7] kconfig: more featured minimum module configs
In-Reply-To: <20090501120100.GC24706@elte.hu>
Message-ID: <alpine.DEB.2.00.0905011926330.20374@gandalf.stny.rr.com>
References: <20090430185022.122124349@goodmis.org> <20090430191001.GA14108@elte.hu> <alpine.DEB.2.00.0904301854230.20374@gandalf.stny.rr.com> <20090501120100.GC24706@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 1 May 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Thu, 30 Apr 2009, Ingo Molnar wrote:
> > 
> > > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > > 
> > > > This set of patches adds on top of my previous post.
> > > > 
> > > > It fixes CONFIG_IKCONFIG when CONFIG_IKCONFIG_PROC is not set.
> > > >  (gcc optimizes the config out!)
> > > > 
> > > > As a request from Ingo, it now enables IKCONFIG and will also use 
> > > > various locations to find a config to base against.
> > > 
> > > hm, now 'make localyesconfig' done on a Fedora distro kernel 
> > > produces something very close to an allyesconfig:
> > > 
> > >  -rw-rw-r-- 1 mingo mingo 91930 2009-04-30 20:03 .config
> > >  aldebaran:~/linux/linux> grep =y .config | wc -l
> > >  3398
> > > 
> > > is that expected?
> > 
> > What config did it use? If it uses an allyesconfig that was 
> > already made then it will not disable anything.
> 
> i used a regular config - then i also tried an allnoconfig - but no 
> change in the result, bloated .config.

Could you send me the config it used (it should print out which one it 
used) and the output of lsmod. Then I can test it locally.

Thanks,

-- Steve

