Return-Path: <linux-kernel-owner+w=401wt.eu-S1756745AbZEDOzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbZEDOzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 10:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755541AbZEDOy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 10:54:59 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45724 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591AbZEDOy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 10:54:58 -0400
Date: Mon, 4 May 2009 16:59:33 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 7/7] kconfig: search for a config to base the local(mod|yes)config on
Message-ID: <20090504145933.GJ23223@one.firstfloor.org>
References: <20090430185022.122124349@goodmis.org> <20090430185223.792841532@goodmis.org> <87fxflgj2q.fsf@basil.nowhere.org> <1241440086.7620.4877.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241440086.7620.4877.camel@twins>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 02:28:06PM +0200, Peter Zijlstra wrote:
> On Mon, 2009-05-04 at 14:15 +0200, Andi Kleen wrote:
> > Steven Rostedt <rostedt@goodmis.org> writes:
> > 
> > > Here's the list and order of search:
> > >
> > >   /proc/config.gz
> > >   /boot/vmlinuz-`uname -r`
> > >   vmlinux  # local to the directory
> > >   /lib/modules/`uname -r`/kernel/kernel/configs.ko
> > >   kernel/configs.ko
> > >   kernel/configs.o
> > >   .config
> > 
> > 
> > That seems like the wrong order. ./.config should always be first for
> > compatibility. 
> > 
> > That order would completely wreck all my build scripts, and I suspect
> > others too.
> 
> Quite, except that I hardly ever have a ./.config since I make extensive
> use of O=foo

yes I do too.  I meant $O/.config sorry

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
