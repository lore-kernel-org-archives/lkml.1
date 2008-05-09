Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbYEIETB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbYEIETB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 00:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbYEIESv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 00:18:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60876 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbYEIESu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 00:18:50 -0400
Date: Thu, 8 May 2008 21:18:02 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Adrian Bunk <bunk@kernel.org>, linux-next@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: linux-next: the purge :-)
Message-ID: <20080509041802.GA16414@kroah.com>
References: <20080508112130.fd574b50.sfr@canb.auug.org.au> <20080508042753.GA6876@kroah.com> <20080508062715.GE14951@cs181133002.pp.htv.fi> <20080508220443.GE7705@kroah.com> <20080509111608.09574cf0.sfr@canb.auug.org.au> <20080509034427.GA14584@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080509034427.GA14584@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 08:44:27PM -0700, Greg KH wrote:
> On Fri, May 09, 2008 at 11:16:08AM +1000, Stephen Rothwell wrote:
> > Hi Greg,
> > 
> > On Thu, 8 May 2008 15:04:43 -0700 Greg KH <greg@kroah.com> wrote:
> > >
> > > On Thu, May 08, 2008 at 09:27:15AM +0300, Adrian Bunk wrote:
> > > > On Wed, May 07, 2008 at 09:27:53PM -0700, Greg KH wrote:
> > > > > 
> > > > > I've now moved my trees around a bit, and would like it if you could
> > > > > include the following, in this order (the # NEXT_BASE variable is set in
> > > > > them to make sure things get ordered properly.)
> > > > > 	driver-core.next
> > > > > 	usb.next
> > > > > 	driver-core
> > > > > 	usb
> > > > > 	ldp.next
> > > > > 
> > > > > The ".next" trees are what is going to Linus before the next major
> > > > > release happens (bugfixes and new device ids at this point in time for
> > > > > example.)  The other trees are what is going to go to Linus after the
> > > > > next major kernel is out.
> 
> Ok, I'll go rename them to be ".current" instead of ".next"

Now done, the sequence is:
	driver-core.current
	usb.current
	driver-core
	usb
	ldp.next

I left ldp.next as that is really only for the -next tree.

If you have any problems with this, please let me know.

thanks,

greg k-h
