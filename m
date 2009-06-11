Return-Path: <linux-kernel-owner+w=401wt.eu-S1757328AbZFKSsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328AbZFKSsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 14:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbZFKSsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 14:48:33 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:59005 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479AbZFKSsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 14:48:32 -0400
Date: Thu, 11 Jun 2009 20:50:49 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Performance Counters for Linux
Message-ID: <20090611185049.GB7658@uranus.ravnborg.org>
References: <20090611160329.GA3366@elte.hu> <20090611161714.GA5008@infradead.org> <alpine.LFD.2.01.0906110922080.3573@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906110922080.3573@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 09:26:55AM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 11 Jun 2009, Christoph Hellwig wrote:
> >
> > Err, no.   This adds tons of userspace code into tools/ which
> > should not be in the kernel tree but a proper package.
> 
> I disagree.
> 
> We've had tons of cases where we tried to "separate" the user-land code 
> and the kernel code, in the name of "beauty" of whatever.
> 
> It's almost invariably a disaster.

This is cheating. I had this as a topic for the kernel summit and
was looking forward to read an interesting article about people
dancing on the table and fighting in the corners about it.
[I do not attend myself]

People say that this would be a nightmare for the packagers.
I frankly do not see what the issue is here.

We should be able to add the necessary stuff to create the few popular
package formats.
And tools like kernels may update 4 times/year with ease - so the kernel
release frequency should be a non-issue too.

Others just say "no userspace in the kernel" - and I honestly have not understood why.


Where to draw the line?
We can ask a few simple questions:
- Are the tool part of a kernel hackers toolbox?
- Are the tool maintained by kernel people?
- Are the tool updated with new features in the kernel (*)?

If the answer is yes it is a good candidate.

(*) No excuse for ABI changes..


Simple example. I needed vmstat on my embedded platfrom the other day.
Got lots of hits on google but could not find the source - and gave up as I was busy.
[Today I found it in second try - sigh.]

	Sam
