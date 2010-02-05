Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934128Ab0BFAJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 19:09:15 -0500
Received: from cantor.suse.de ([195.135.220.2]:43637 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933744Ab0BFAJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 19:09:13 -0500
Date: Fri, 5 Feb 2010 15:58:33 -0800
From: Greg KH <gregkh@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Verges <chrisv@cyberswitching.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Rob Owings <rowings@thermistor.com>
Subject: Re: [PATCH] linux-2.6.32-directemp
Message-ID: <20100205235833.GA16411@suse.de>
References: <68FBE0F3CE97264395875AC1C468F22C24A5BD@mail03.cyberswitching.local> <20100205124038.4f1e83ac.akpm@linux-foundation.org> <68FBE0F3CE97264395875AC1C468F22C24A608@mail03.cyberswitching.local> <20100205134600.59eb8fae.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100205134600.59eb8fae.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 05, 2010 at 01:46:00PM -0800, Andrew Morton wrote:
> On Fri, 5 Feb 2010 13:32:27 -0800
> "Chris Verges" <chrisv@cyberswitching.com> wrote:
> 
> > > *snip*
> > 
> > Hi Andrew,
> > 
> > Thanks for the technical review.  I'll make the changes and send back a
> > new patch.  Would you like a patch against your -mm tree or a fresh
> > patch against linux-2.6.32?
> 
> I guess a new patch would be best - #1 was a bit of a mess.  Please
> give the patch a good title (I chose "usb: QTI DirecTEMP USB
> thermometer/hygrometer driver support") and if possible, include it
> within the body of the email so more people are likely to look at it. 
> If your email client can't do that correctly, use a text/plain
> attachment.

Sorry, but no, this driver will not be accepted, as it can be done just
fine from userspace instead of a kernel driver, as discussed before.

We have removed drivers from the kernel for this very reason, we don't
want to add new ones in with the same problem.

thanks,

greg k-h
