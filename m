Return-Path: <linux-kernel-owner+w=401wt.eu-S1756234AbYE3CoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbYE3CoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 22:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbYE3CoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 22:44:10 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51169 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbYE3CoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 22:44:07 -0400
Date: Thu, 29 May 2008 19:42:35 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@suse.de>, David Brownell <david-b@pacbell.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [GIT PATCH] USB fixes for 2.6.26-rc4
Message-ID: <20080530024235.GC5787@kroah.com>
References: <20080529215808.GA3759@suse.de> <Pine.LNX.4.44L0.0805292143001.26334-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0805292143001.26334-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 09:44:42PM -0400, Alan Stern wrote:
> On Thu, 29 May 2008, Greg KH wrote:
> 
> > On Thu, May 29, 2008 at 02:48:39PM -0700, David Brownell wrote:
> > > On Thursday 29 May 2008, Greg KH wrote:
> > > >       USB: EHCI: fix performance regression
> > > 
> > > That's not a regresssion at all!  Plus, this patch shouldn't
> > > have included the timeout change.  The timeout change is why
> > > I didn't ACK this patch...
> > 
> > Well, I was misinformed by Alan Stern about this then, sorry for missing
> > that you didn't ack this one (you acked the other patches in this series
> > though.)
> 
> The notion that this was a regression came about by mistake.  It was 
> stated that 2.6.24 worked better than 2.6.25; apparently that remark 
> was wrong.
> 
> > Alan, care to make up a patch to fix this?  Or should I just revert it
> > in the tree as-is?
> 
> Given that the issues are not yet resolved among the developers, I 
> think reverting the patch for now is the best course.

Ok, will go do so.

thanks,

greg k-h
