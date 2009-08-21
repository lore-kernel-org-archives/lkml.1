Return-Path: <linux-kernel-owner+w=401wt.eu-S1753256AbZHURjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbZHURjH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 13:39:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbZHURjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 13:39:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35442 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbZHURjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 13:39:05 -0400
Date: Fri, 21 Aug 2009 13:39:02 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, peterz@infradead.org, torvalds@linux-foundation.org,
       tytso@mit.edu, arjan@infradead.org, greg@kroah.com, mcgrof@gmail.com,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org, sam@ravnborg.org,
       corbet@lwn.net, sourcejedi.lkml@googlemail.com, andi@firstfloor.org,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
Subject: Re: [PATCH 00/14] kconfig: streamline distro configs for testers
In-Reply-To: <20090821163220.GB20898@elte.hu>
Message-ID: <alpine.DEB.2.00.0908211309020.30182@gandalf.stny.rr.com>
References: <20090819025634.987354707@goodmis.org> <20090820143025.7134930f.akpm@linux-foundation.org> <alpine.DEB.2.00.0908201741370.16405@gandalf.stny.rr.com> <20090820151326.b43038ce.akpm@linux-foundation.org> <20090821135249.GB30346@elte.hu>
 <alpine.DEB.2.00.0908211106560.16405@gandalf.stny.rr.com> <20090821163220.GB20898@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 21 Aug 2009, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> I'm wondering, what do you think about Vegard's 'warn about complex 
> selects' feature for kconfig which he submitted some time ago:
> 
>   http://lkml.org/lkml/2008/5/4/13
> 
> That's a really sore kconfig spot we have. It's not a bug, but it 
> sure bites people again and again, and it would be nice to have some 
> built-in mechanism that gently nudges us away from complex selects. 
> (many of which are inadvertent or become complex after the fact)

I'll take a look at that too. We need to be careful about kicking out too 
many warnings. Perhaps a "make configcheck" is in order that will do 
various checks. This is very similar to my check for select dependency 
error patch:

  http://lkml.org/lkml/2009/2/21/2

I may take a look at getting both of these in (or a merge of the two).

-- Steve

