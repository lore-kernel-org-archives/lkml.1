Return-Path: <linux-kernel-owner+w=401wt.eu-S932693AbYBBXcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693AbYBBXcz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 18:32:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756652AbYBBXcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 18:32:46 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40939 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764112AbYBBXcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 18:32:46 -0500
Date: Sat, 2 Feb 2008 15:23:45 -0800
From: Greg KH <greg@kroah.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@osdl.org>,
       pcihpd-discuss@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [patch] pci: pci_enable_device_bars() fix
Message-ID: <20080202232345.GB20240@kroah.com>
References: <20080201231147.GA18174@suse.de> <20080202111322.GA30767@elte.hu> <20080202184441.GA12301@suse.de> <20080202190558.GB27927@elte.hu> <47A4D8E4.8030708@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A4D8E4.8030708@garzik.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2008 at 03:56:04PM -0500, Jeff Garzik wrote:
> Ingo Molnar wrote:
> > * Greg KH <gregkh@suse.de> wrote:
> > 
> >>> ( This call has been introduced upstream 3 weeks ago by commit
> >>>   8a4df120b07, but the PCI tree has apparently not been fully 
> >>>   re-tested with Linus-latest since that point. )
> >> Wait, my testing caught this.  I made the change to the patch myself, 
> >> adding the needed conversion to my tree, it's here, on my disk!
> >>
> >> Oh crap, I never checked it in.
> >>
> >> /me goes off to sulk in shame.
> > 
> > you might want to join the (sizable) club of us deeply ashamed people 
> > who recently introduced upstream build failures :-/
> 
> Personal CC differences aside <grin> I do think you guys both do a good 
> job of staying on top of your subsystems.

Heh, thanks.

> We all wear the brown paper bag on occasion, and with the "merge 
> maelstrom" during each merge window, I'm quite frankly amazed at how 
> _little_ stuff get broken overall.

Yeah, I re-ran some statistics the other day on our kernel development
rate, and changed my formula after Andrew accused me of severely
undercounting the rate of change.

Turns out that as of 2.6.24-rc8 for the 2.6.24 kernel release we did:
	lines added per day:	4945
	lines removed per day:	2006
	lines modified per day:	1702

And note, that is real stuff, not renames or file moves at all, git
handles not reporting that.

That's for the 99 days that it took to do 2.6.24-rc8 (I need to re-run
the scripts now that 2.6.24 is out.)

It's fricken scarily amazing that things are still working at all...

Just something to make you all sleep well at night :)

thanks,

greg k-h
