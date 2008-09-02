Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbYIBRRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbYIBRRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 13:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751760AbYIBRQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 13:16:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:51573 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbYIBRQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 13:16:54 -0400
Date: Tue, 2 Sep 2008 10:12:36 -0700
From: Greg KH <gregkh@suse.de>
To: "Brian G. Merrell" <bgmerrell@novell.com>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>
Subject: Re: [patch 00/03] USB-IP patches
Message-ID: <20080902171236.GC9524@suse.de>
References: <20080828230016.GA15014@kroah.com> <20080830055007.GB3422@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080830055007.GB3422@novell.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 11:50:08PM -0600, Brian G. Merrell wrote:
> On Thu, Aug 28, 2008 at 04:00:16PM -0700, greg@kroah.com wrote:
> > Here's 3 patches that adds USB-IP functionality code to the kernel tree.
> > 
> > It is against 2.6.27-rc4, and has been added to the -staging tree.  If
> > there are no major objections, I'll also queue it up in the usb tree for
> > submission into 2.6.28.
> > 
> > The code is based on Takahiro's great work that has been sitting outside
> > of the kernel for many many years now.  Brian Merrell took the most
> > recent version of the code, cleaned it up and sent it to me.  I did more
> > cleanup and split the patch into 3 pieces, making it a bit easier to
> > work with.
> > 
> > There are still a number of checkpatch.pl warnings/errors emitted, and
> > Brian said he would work on them in the upcoming weeks, but they don't
> > distract from the basic functionality and a good review would be nice to
> > have.
> 
> I will indeed continue to work on getting rid of the checkpatch.pl
> warnings/errors during the upcoming weeks.  I already eliminated the
> ones I could figure out without too much effort;  I am sure the
> remaining ones are trivial to many of you out there, so I welcome
> any suggestions.

The kthread one looks like you will have to change a bit of the code,
all of the other remaining ones should be self-explanatory.  If not,
please let us know and we'll be glad to help out.

Can you also work to address all of the review comments made on the code
so far as well?  I don't know how much time you have to work on this,
but for now I'll let you send me changes and not do anything on the code
myself.  Sound good?

thanks,

greg k-h
