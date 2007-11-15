Return-Path: <linux-kernel-owner+w=401wt.eu-S1764083AbXKOR6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764083AbXKOR6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 12:58:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757431AbXKOR6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 12:58:41 -0500
Received: from mail.suse.de ([195.135.220.2]:49927 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562AbXKOR6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 12:58:41 -0500
Date: Thu, 15 Nov 2007 09:57:30 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 08/16] skge: fix ram buffer size calculation
Message-ID: <20071115175730.GB24531@suse.de>
References: <20071115060353.071060513@mini.kroah.org> <20071115064037.GH18951@kroah.com> <alpine.LFD.0.9999.0711150810130.2786@woody.linux-foundation.org> <20071115163201.GA24087@suse.de> <alpine.LFD.0.9999.0711150846280.2786@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0711150846280.2786@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 08:48:58AM -0800, Linus Torvalds wrote:
> 
> 
> On Thu, 15 Nov 2007, Greg KH wrote:
> 
> > On Thu, Nov 15, 2007 at 08:11:30AM -0800, Linus Torvalds wrote:
> > > > 
> > > > patch 7fb7ac241162dc51ec0f7644d4a97b2855213c32 in mainline.
> > > 
> > > This one is getting reverted in mainline in about five minutes (unless I 
> > > find an email from Stephen to address the reported regression - I haven't 
> > > gone through all my emails yet), so I don't think it should make it into 
> > > stable.
> > 
> > Thanks for letting me know which patch is causing the problem, I just
> > got another report of the skge driver not working with all of these
> > patches applied.
> 
> I suspect that's the same report.
> 
> > It looks like I'll just drop this one from the patch list, unless
> > Stephen has a better idea.
> 
> This is my commit message for the revert - note the suggested possible 
> fix (but also why I didn't apply it, and why things got reverted).

Ok, I've now dropped this patch from the stable queue.  Stephen, if you
get something that works, and is in Linus's tree, feel free to resend it
to stable@kernel.org.

thanks,

greg k-h
