Return-Path: <linux-kernel-owner+w=401wt.eu-S1752624AbYKSDEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbYKSDEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 22:04:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbYKSDEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 22:04:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44358 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbYKSDEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 22:04:36 -0500
Date: Tue, 18 Nov 2008 22:04:33 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Paul Mackerras <paulus@samba.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 0/7] Porting dynmaic ftrace to PowerPC
In-Reply-To: <18723.31762.522696.647294@cargo.ozlabs.ibm.com>
Message-ID: <alpine.DEB.1.10.0811182150530.14914@gandalf.stny.rr.com>
References: <20081116212428.938752312@goodmis.org> <18720.42209.880409.297291@cargo.ozlabs.ibm.com> <alpine.DEB.1.10.0811171035530.2919@gandalf.stny.rr.com> <alpine.DEB.1.10.0811180853390.15003@gandalf.stny.rr.com>
 <18723.31762.522696.647294@cargo.ozlabs.ibm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 19 Nov 2008, Paul Mackerras wrote:

> Steven Rostedt writes:
> 
> > Can I add your Acked-by: to all these patches that I submitted? I'm going 
> > to recommit them with a consistent subject (all lower case ppc), but I'm 
> > not going to change the patches themselves.
> > 
> > Would you two be fine with that? Or at least one of you?
> 
> My preference would be for the patches to go through the powerpc tree
> unless there is a good reason for them to go via another tree.

I have no problem with that. The only thing is that we have a lot of
pending work still in the linux-tip tree, which you may need to pull
in to get these patches working. Well, there's two or three commits in the 
generic code that I know the PPC code is dependent on.

I could give you a list of commits in tip that need to go mainline first
before we can pull in the PPC changes. Then you could wait till those 
changes make it into 29 and then you could push the PPC modifications in 
from your tree.

> 
> The style we use for the headline is "powerpc: Add xyz feature" or
> "powerpc/subsystem: Fix foo bug".

We've been using the "ftrace: subject" format for most of our ftrace 
commits, and have been using "ftrace, ppc: subject" or ppc32 or ppc64 for 
those. But since this is a powerpc port, I will conform to your style.

> 
> As for the acked-by, I feel I first need to go through the whole
> series again with the changes you have made recently.  Have you
> reworked the earlier patches to avoid introducing any bugs, rather
> than just fixing the bugs with later patches?  If you haven't, are you
> sure that the bugs won't cause any problems in bisecting?

Fair enough. I'll rework the patches again to fold back in the changes 
based on your comments, as well as the comments of others. When I'm done, 
I'll repost to the list. This way, if you pull them in, you can add your 
Signed-off-by yourself.

> 
> Also, what's the best place to find the latest patch set?

I'll be keeping the changes in my repo:

 git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

  branch tip/ppc

Note, this branch is based on top of Ingo's linux-tip tree. I can make a 
a branch "ppc" that will be based on top of mainline, and I can add the 
patches needed to get PPC working. The generic commits will have the 
"ftrace: " format.

The generic ftrace patches will still need to go in through linux-tip. But 
when they do, feel free to push the PowerPC port in.  Anyway, you are the 
ones that can test it better than we can. I have two PPC boxes that I test 
on, but I'm sure you have a lot more.

> 
> Thanks again for doing all this work.

Thank you for the reviews.

-- Steve

