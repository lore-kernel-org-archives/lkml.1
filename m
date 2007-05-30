Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbXE3Nls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbXE3Nls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 09:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbXE3Nll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 09:41:41 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:57499 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbXE3Nlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 09:41:40 -0400
Date: Wed, 30 May 2007 09:40:28 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Daniel Walker <dwalker@mvista.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Bill Huey <billh@gnuppy.monkey.org>, Jason Baron <jbaron@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] lockstat: core infrastructure
In-Reply-To: <20070530132431.GA23947@elte.hu>
Message-ID: <Pine.LNX.4.58.0705300936390.15841@gandalf.stny.rr.com>
References: <20070529125248.877196281@chello.nl> <20070529130107.112347096@chello.nl>
 <1180470525.32594.71.camel@imap.mvista.com> <20070530132431.GA23947@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> > [...] Most architecture implement a jiffies sched_clock() w/ 1
> > millisecond or worse resolution.. [...]
>
> weird that you count importance by 'number of architectures', while 98%
> of the installed server base is x86 or x86_64, where sched_clock() is
> pretty precise ;-)
>


I can understand Daniel's POV (from working at TimeSys once upon a time).
He works for Monta Vista which does a lot with embedded systems running on
something other than x86.  So from Daniel's POV, those "number of
architectures" is of importance. While, from those that do server work
where x86 is now becoming the dominant platform, our focus is on those.

As long as the work doesn't "break" an arch. We can argue that sched_clock
is "good enough".  If someone wants better accounting of locks on some
other arch, they can simply change sched_clock to be more precise.

-- Steve

