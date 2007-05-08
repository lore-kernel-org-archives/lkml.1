Return-Path: <linux-kernel-owner+w=401wt.eu-S1032529AbXEHWgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032529AbXEHWgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032502AbXEHWgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:36:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:55381 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032515AbXEHWgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:36:46 -0400
Date: Tue, 8 May 2007 15:37:36 -0700
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: David Brownell <david-b@pacbell.net>, Andrew Morton <akpm@osdl.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-usb-devel@lists.sourceforge.net,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Adrian Bunk <bunk@stusta.de>,
       Tony Olech <tony.olech@elandigitalsystems.com>
Subject: Re: [PATCH] different values for OHCI_QUIRK_ZFMICRO
Message-ID: <20070508223736.GA2440@suse.de>
References: <20070111222627.66bb75ab.akpm@osdl.org> <20070220000654.GK13958@stusta.de> <20070329150638.83dcf1fa.randy.dunlap@oracle.com> <200703291524.01834.david-b@pacbell.net> <20070508151753.8a8df27c.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508151753.8a8df27c.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 03:17:53PM -0700, Randy Dunlap wrote:
> On Thu, 29 Mar 2007 15:24:00 -0700 David Brownell wrote:
> 
> > On Thursday 29 March 2007 3:06 pm, Randy Dunlap wrote:
> > > On Tue, 20 Feb 2007 01:06:54 +0100 Adrian Bunk wrote:
> > > 
> > > > On Sun, Jan 14, 2007 at 06:36:10AM -0800, David Brownell wrote:
> > > > > On Sunday 14 January 2007 1:10 am, Adrian Bunk wrote:
> > > > > > <--  snip  -->
> > > > > 
> > > > > Waiting for Tony to submit bugfixes to his driver...
> > > > 
> > > > Still unfixed as of 2.6.20-mm1.
> > >
> > > so is there a patch around for this yet?
> > > 
> > > or shall someone other than Tony (??) make one?
> > 
> > ISTR posting the appended patch back in January; it's been
> > refreshed since then.  Presumably it still works.
> > 
> > - Dave
> 
> Oh, Greg, can we get this merged some day soon, please?
> David posted this patch on 2007-FEB-08.
> 
> 
> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Partial fix for bogosity in the ftdi-elan and u13-hcd drivers ... these
> have no business including with the internals of other drivers, much less
> doing so in a broken way!!
> 
> Updated for 2.6.21-git10.

This is already in my tree, and should show up in the next -mm and will
be going to Linus in time for 2.6.22.  He resent it to me a few days
ago, sorry for somehow dropping it back in Feburary :(

thanks,

greg k-h
