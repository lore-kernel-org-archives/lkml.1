Return-Path: <linux-kernel-owner+w=401wt.eu-S1762075AbZFLA04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762075AbZFLA04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 20:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754142AbZFLA0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 20:26:48 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45091 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbZFLA0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 20:26:48 -0400
Date: Fri, 12 Jun 2009 01:26:34 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Marcel Holtmann <marcel@holtmann.org>, Ingo Molnar <mingo@elte.hu>,
       Martin Bligh <mbligh@google.com>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Performance Counters for Linux
Message-ID: <20090612002634.GY8633@ZenIV.linux.org.uk>
References: <alpine.LFD.2.01.0906111127520.3573@localhost.localdomain> <20090611202341.GA23590@elte.hu> <1244753357.27363.82.camel@violet> <20090611210810.GA9317@uranus.ravnborg.org> <1244755036.27363.93.camel@violet> <20090611212635.GA9446@uranus.ravnborg.org> <4A3182C6.803@gmail.com> <alpine.LFD.2.01.0906111521210.3535@localhost.localdomain> <20090611231952.GX8633@ZenIV.linux.org.uk> <alpine.LFD.2.01.0906111624320.3237@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906111624320.3237@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 04:25:19PM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 12 Jun 2009, Al Viro wrote:
> > 
> > Linus, the real question that needs to be answered is this:
> 
> No it's not.
> 
> People have already told you that the intent isn't to change the ABI. So 
> your whole "hard-hitting journalism" is just bogus posturing.
> 
> What does this have to do with anything?

Oh, for...  I can bloody well read, I've seen the reply from Peter and
I've no reasons to doubt his words (and if I had, I would've said so).
Not the issue.  I don't know who you are confusing me with, but for the
record - I have no problem with this particular code being in tree.

I do have a problem with another thing: suggestions I've heard quite a few
times before; basically, "let's allow special breakable ABIs for use by
userland code living in kernel tree and tied to specific version".  No,
I'm not saying that this is what's happening with that merge.  But your
support for userland code in the tree (and BTW, I agree that it's a good
idea - hell, mount(8) makes a good candidate as far as I'm concerned) will
be parsed as green light for that.  Has been already, in this thread.

So could you please clarify the situation?  If the ABI compatibility
requirements remain the same as they used to be, whether the userland code
is in-tree or not, I'm fine with the entire thing.  If they do not (and *ONLY*
in that case), I think we have a real problem.

For the record, I don't give a damn about packaging-related arguments and
theories about keeping userland source separate as a matter of some principle.
As far as I'm concerned, it's not a problem - as long as we take care of
later version's $TOOL working on older kernel as well as $TOOL from that
older kernel used to work, I'm fine with it.

I realize that multi-side flamefests are messy, but let's keep track of
who's saying what, OK?
