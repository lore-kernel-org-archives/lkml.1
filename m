Return-Path: <linux-kernel-owner+w=401wt.eu-S1752541AbZIRPtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbZIRPtJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 11:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbZIRPtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 11:49:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45854 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751106AbZIRPtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 11:49:06 -0400
Date: Fri, 18 Sep 2009 08:48:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrey Rahmatullin <wrar@altlinux.org>
cc: Peter Volkov <pva@gentoo.org>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31 regression: system hang after pptp connection
 established
In-Reply-To: <20090918153744.GJ28743@wrars-comp.wrarsdomain>
Message-ID: <alpine.LFD.2.01.0909180843210.4950@localhost.localdomain>
References: <20090918153744.GJ28743@wrars-comp.wrarsdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 18 Sep 2009, Andrey Rahmatullin wrote:
>
> On Thu, Sep 17, 2009 at 11:59:13PM +0400, Peter Volkov wrote:
> > Is this problem known? 
> Yes, it's described at http://bugzilla.kernel.org/show_bug.cgi?id=14179
> since Tuesday.
> 
> On Fri, Sep 18, 2009 at 07:16:39AM -0700, Linus Torvalds wrote:
> > > The patch fixes the problem here. Thank you very much.
> > Hey, thank _you_ for the sysrq output, that made it quite debuggable.
> > Committed as 202c4675c, and I cc'd stable.
> Thanks for the fix, but should I send bugreports directly here next time
> instead of filing a bug in bugzilla.kernel.org and waiting for response
> that will never come?

Bugzilla is great, but you should _also_ target the maintainers directly 
and let them know.  And especially if you have bisected things, always cc 
everybody that is listed in the commit.

Otherwise, what happens is that other people not directly involved will 
eventually look at the regression list, and see it - but that generally 
happens much later. So things will get fixed from just the bugzilla report 
too, but you'll have a much longer latency than required.

In fact, if you can bisect it to a single commit (especially a small one 
like this), then bugzilla is the secondary, rather than the primary place. 
Bugzilla is great for keeping track of things and trying to avoid losing 
reports, but that comes at the expense of not being very convenient for 
short-term stuff.

So if you have a very targeted bugreport, and know who to send a report 
to, try the direct route first. Then, if nothing happens immediately, open 
a bugzilla (or open the bugzilla immediately, just in case, but see it 
as a "fallback" thing).

			Linus
