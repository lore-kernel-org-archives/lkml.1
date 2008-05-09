Return-Path: <linux-kernel-owner+w=401wt.eu-S1754726AbYEIEOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbYEIEOf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 00:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbYEIEOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 00:14:24 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36066 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbYEIEOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 00:14:23 -0400
Date: Thu, 8 May 2008 20:44:27 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Adrian Bunk <bunk@kernel.org>, linux-next@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: linux-next: the purge :-)
Message-ID: <20080509034427.GA14584@kroah.com>
References: <20080508112130.fd574b50.sfr@canb.auug.org.au> <20080508042753.GA6876@kroah.com> <20080508062715.GE14951@cs181133002.pp.htv.fi> <20080508220443.GE7705@kroah.com> <20080509111608.09574cf0.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080509111608.09574cf0.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 11:16:08AM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Thu, 8 May 2008 15:04:43 -0700 Greg KH <greg@kroah.com> wrote:
> >
> > On Thu, May 08, 2008 at 09:27:15AM +0300, Adrian Bunk wrote:
> > > On Wed, May 07, 2008 at 09:27:53PM -0700, Greg KH wrote:
> > > > 
> > > > I've now moved my trees around a bit, and would like it if you could
> > > > include the following, in this order (the # NEXT_BASE variable is set in
> > > > them to make sure things get ordered properly.)
> > > > 	driver-core.next
> > > > 	usb.next
> > > > 	driver-core
> > > > 	usb
> > > > 	ldp.next
> > > > 
> > > > The ".next" trees are what is going to Linus before the next major
> > > > release happens (bugfixes and new device ids at this point in time for
> > > > example.)  The other trees are what is going to go to Linus after the
> > > > next major kernel is out.
> > > >...
> > > 
> > > So the "next" in your .next has the opposite meaning of the one in 
> > > linux-next?
> > 
> > It does?  I was following the convention that people used for their git
> > tree branch names I thought.
> 
> In their git trees, people usually have a branch called "for-linus" for
> fixes to the current tree and "for-next" or "for-akpm" (or "devel" or
> "testing") for stuff for the next release).
> 
> > > Can you name it .fixes instead to make it clearer?
> > 
> > I can name it anything that Stephen wants me to, I'll defer to him as he
> > is the only one that will ever really see this.
> 
> In linux-next, when the choice is left to me I name the trees like this:
> 
> xxx-current	bug fixes and stuff not take yet for Linus' current tree
> xxx		stuff for the next release.
> 
> Today I have used your names, but Adrian is correct that they are
> inconsistent with (at least) my normal usage.

Ok, I'll go rename them to be ".current" instead of ".next"

> One question: is the driver in ldp.next intended for 2.6.26?

No, 2.6.27, it will get sent to Jeff probably next week when I get the
last round of proposed patches into it.  But people are using it today,
so it is good for their testing and to work off of.

Same thing goes for the via framebuffer driver that I'll move into
ldp.next next week when the last round of cleanups to it happen.  It too
is for 2.6.27.

> Because if it is, ldp.next should be based on usb.next, not usb. If
> not then ldp.next is wrongly named.

No, the "ldp.next" tree is one kernel release away, I think I put it in
the correct place in the sequence because of this.

If you want me to move it, I'd be glad to do so.

thanks,

greg k-h
