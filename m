Return-Path: <linux-kernel-owner+w=401wt.eu-S1161334AbXBGOZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161334AbXBGOZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 09:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161335AbXBGOZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 09:25:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:55540 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161334AbXBGOZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 09:25:28 -0500
Date: Wed, 7 Feb 2007 06:24:15 -0800
From: Greg KH <greg@kroah.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH] mfd: SM501 core driver
Message-ID: <20070207142415.GE1712@kroah.com>
References: <20070206192628.GA13644@fluff.org.uk> <20070206210930.fc814bf6.akpm@linux-foundation.org> <20070207114825.GA21120@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070207114825.GA21120@fluff.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 07, 2007 at 11:48:25AM +0000, Ben Dooks wrote:
> On Tue, Feb 06, 2007 at 09:09:30PM -0800, Andrew Morton wrote:
> > On Tue, 6 Feb 2007 19:26:28 +0000 Ben Dooks <ben-linux@fluff.org> wrote:
> > > +/* sm501_null_release
> > > + *
> > > + * A release function for the platform devices we create to keep the
> > > + * driver core happy, and stop any crashed when the devices are removed
> > > +*/
> > > +
> > > +static void sm501_null_release(struct device *dev)
> > > +{
> > > +}
> > 
> > Greg might have an opinion on that ;)
> 
> Without this the system OOPses when the driver is removed.

Are you sure about that?  And it's not just an error message being
printed out telling you that you must provide a release function?

And BIG hint, providing an empty release function just to shut up the
kernel is NOT a fix.  You really need to free your memory here, not just
ignore it.

thanks,

greg k-h
