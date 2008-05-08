Return-Path: <linux-kernel-owner+w=401wt.eu-S933818AbYEHWNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933818AbYEHWNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 18:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764233AbYEHWMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 18:12:43 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37497 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764216AbYEHWMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 18:12:41 -0400
Date: Thu, 8 May 2008 15:04:43 -0700
From: Greg KH <greg@kroah.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: linux-next: the purge :-)
Message-ID: <20080508220443.GE7705@kroah.com>
References: <20080508112130.fd574b50.sfr@canb.auug.org.au> <20080508042753.GA6876@kroah.com> <20080508062715.GE14951@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080508062715.GE14951@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 09:27:15AM +0300, Adrian Bunk wrote:
> On Wed, May 07, 2008 at 09:27:53PM -0700, Greg KH wrote:
> > On Thu, May 08, 2008 at 11:21:30AM +1000, Stephen Rothwell wrote:
> > > Greg, you might consider setting up a subset (currently probably
> > > empty) of the ldp tree for drivers that are readier for integration.
> > 
> > Ok, fair enough, I totally understand.
> > 
> > I've now moved my trees around a bit, and would like it if you could
> > include the following, in this order (the # NEXT_BASE variable is set in
> > them to make sure things get ordered properly.)
> > 	driver-core.next
> > 	usb.next
> > 	driver-core
> > 	usb
> > 	ldp.next
> > 
> > The ".next" trees are what is going to Linus before the next major
> > release happens (bugfixes and new device ids at this point in time for
> > example.)  The other trees are what is going to go to Linus after the
> > next major kernel is out.
> >...
> 
> So the "next" in your .next has the opposite meaning of the one in 
> linux-next?

It does?  I was following the convention that people used for their git
tree branch names I thought.

> Can you name it .fixes instead to make it clearer?

I can name it anything that Stephen wants me to, I'll defer to him as he
is the only one that will ever really see this.

thanks,

greg k-h
