Return-Path: <linux-kernel-owner+w=401wt.eu-S1756637AbYE3Box@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbYE3Box (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 21:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbYE3Boo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 21:44:44 -0400
Received: from netrider.rowland.org ([192.131.102.5]:1901 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752708AbYE3Boo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 21:44:44 -0400
Date: Thu, 29 May 2008 21:44:42 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg KH <gregkh@suse.de>
cc: David Brownell <david-b@pacbell.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [GIT PATCH] USB fixes for 2.6.26-rc4
In-Reply-To: <20080529215808.GA3759@suse.de>
Message-ID: <Pine.LNX.4.44L0.0805292143001.26334-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008, Greg KH wrote:

> On Thu, May 29, 2008 at 02:48:39PM -0700, David Brownell wrote:
> > On Thursday 29 May 2008, Greg KH wrote:
> > >       USB: EHCI: fix performance regression
> > 
> > That's not a regresssion at all!  Plus, this patch shouldn't
> > have included the timeout change.  The timeout change is why
> > I didn't ACK this patch...
> 
> Well, I was misinformed by Alan Stern about this then, sorry for missing
> that you didn't ack this one (you acked the other patches in this series
> though.)

The notion that this was a regression came about by mistake.  It was 
stated that 2.6.24 worked better than 2.6.25; apparently that remark 
was wrong.

> Alan, care to make up a patch to fix this?  Or should I just revert it
> in the tree as-is?

Given that the issues are not yet resolved among the developers, I 
think reverting the patch for now is the best course.

Alan Stern

