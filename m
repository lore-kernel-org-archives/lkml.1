Return-Path: <linux-kernel-owner+w=401wt.eu-S1763955AbZD3WyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763955AbZD3WyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 18:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756365AbZD3WyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 18:54:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57040 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763357AbZD3WyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 18:54:13 -0400
Date: Thu, 30 Apr 2009 18:54:11 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 7/7] kconfig: search for a config to base the 
 local(mod|yes)config on
In-Reply-To: <9b2b86520904301504m2906e466ndd8b9e7851bcd59@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0904301853370.20374@gandalf.stny.rr.com>
References: <20090430185022.122124349@goodmis.org>  <20090430185223.792841532@goodmis.org> <9b2b86520904301504m2906e466ndd8b9e7851bcd59@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 30 Apr 2009, Alan Jenkins wrote:

> On 4/30/09, Steven Rostedt <rostedt@goodmis.org> wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> >
> > Instead of using the .config in the local directory. This patch
> > changes streamline_config.pl to search various locations for a config.
> >
> > Here's the list and order of search:
> >
> >   /proc/config.gz
> >   /boot/vmlinuz-`uname -r`
> >   vmlinux  # local to the directory
> >   /lib/modules/`uname -r`/kernel/kernel/configs.ko
> >   kernel/configs.ko
> >   kernel/configs.o
> >   .config
> >
> > Once it finds a file that contains a config (it checks if the binary
> > objects have configs first) it then uses it to create the .config
> > with minimum modules needed.
> 
> Maybe this has already been discussed, but is there some reason for
> omitting /boot/config-`uname -r`?  My understanding as a user of a
> specific distribution was that kernel packages provide these files,
> and therefore do not feel the need to enable CONFIG_IKCONFIG.

You know, I did not even think about that :-/

I'll update that.

Thanks,

-- Steve

