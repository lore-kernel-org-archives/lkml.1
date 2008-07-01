Return-Path: <linux-kernel-owner+w=401wt.eu-S1758219AbYGATQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219AbYGATQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 15:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbYGATQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 15:16:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:44982 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888AbYGATP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 15:15:59 -0400
Date: Tue, 1 Jul 2008 12:13:43 -0700
From: Greg KH <gregkh@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Stefan Becker <Stefan.Becker@nokia.com>, linux-usb@vger.kernel.org,
       ext David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       ext Leonardo Chiquitto <leonardo.lists@gmail.com>
Subject: Re: [PATCH] USB: fix interrupt disabling for HCDs with shared
	interrupt handlers
Message-ID: <20080701191343.GA26068@suse.de>
References: <20080701182543.GA32098@suse.de> <Pine.LNX.4.44L0.0807011456370.6796-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0807011456370.6796-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 02:59:38PM -0400, Alan Stern wrote:
> On Tue, 1 Jul 2008, Greg KH wrote:
> 
> > Hm, isn't this also an issue in 2.6.25 as well?  I've had a few very
> > strange reports of USB just locking up in 2.6.25, could this also be the
> > cause there?
> 
> It could go back a lot farther than that.  I don't think our interrupt 
> setup has been changed significantly for a long time, with one 
> exception: We added the IRQF_DISABLED flag fairly recently.  But of 
> course, we now know that it doesn't do what we expected.
> 
> It's surprising that more people haven't experienced this problem and 
> reported it.

Ok, I'll queue it up for -stable as well.

> > Alan and Dave, do you both ack this thing?  I know you've been involved
> > in creating it, just want to get the formal approval :)
> 
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> 
> There still are a few places where spaces were used instead of tabs for 
> indenting.  Aside from that it looks fine.

Thanks, I'll clean that up by hand, not a big deal :)

greg k-h
