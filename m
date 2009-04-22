Return-Path: <linux-kernel-owner+w=401wt.eu-S1753554AbZDVXW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbZDVXW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 19:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbZDVXWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 19:22:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57394 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbZDVXWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 19:22:49 -0400
Date: Wed, 22 Apr 2009 16:13:31 -0700
From: Greg KH <gregkh@suse.de>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Subject: Re: [PATCH 0/3] Fix rt28{6,7}0sta to use firmware loader
Message-ID: <20090422231331.GB16383@suse.de>
References: <1239589992.18110.117.camel@deadeye.i.decadent.org.uk> <20090413024445.GA12860@suse.de> <1239667961.18110.166.camel@deadeye.i.decadent.org.uk> <20090414022418.GA17760@suse.de> <1240222746.17844.35.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240222746.17844.35.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 11:19:06AM +0100, David Woodhouse wrote:
> On Mon, 2009-04-13 at 19:24 -0700, Greg KH wrote:
> > On Tue, Apr 14, 2009 at 01:12:41AM +0100, Ben Hutchings wrote:
> > > On Sun, 2009-04-12 at 19:44 -0700, Greg KH wrote:
> > > > On Mon, Apr 13, 2009 at 03:33:12AM +0100, Ben Hutchings wrote:
> > > > > Greg,
> > > > > 
> > > > > The Ralink drivers rt2860sta, rt2870sta and rt3070sta contain non-free
> > > > > firmware which should be distributed separately.
> > > > 
> > > > Where is it now distributed?  I don't want to break people's machines
> > > > that were working before this patch is applied.
> > > 
> > > The canonical source is
> > > <http://www.ralinktech.com/ralink/Home/Support/Linux.html>
> > 
> > Yes, and that is where I got the code that is in the driver tree that
> > you are objecting to now :)
> 
> You shouldn't have done. We stopped including firmware for new wireless
> drivers _years_ ago. It's perfectly normal that users are expected to
> fetch the firmware separately (or their distribution does it for them).

Sorry, I should have added it to your tree in the beginning.

> > > The files are now also in the Debian repository for our firmware-nonfree
> > > package and in <http://git.decadent.org.uk/git/linux-firmware.git>.
> > > I've asked David Woodhouse to pull from that into his linux-firmware.git
> > > so that they get into other distros.
> 
> I'd be a lot happier with that having a signed-off-by from within
> Ralink, even though the licence is unambiguous. But I've pulled it
> anyway, this time. You can download the 'release' at
> http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=snapshot;h=HEAD

Nice, thanks for doing this.

> (Still haven't really worked out what the best strategy for 'releases'
> is, given that people should just be using the latest version from the
> tree. Maybe an automatic git-archive from cron each day, if something's
> change from the previous day?)

Yes, that would be a good idea.  And a way to send an email to people
who are packaging this up for distros to know and go update them would
be good as well.

I have a firmware package now in the Gentoo tree, and am working on
making the SuSE one public (it's right now buried behind the firewall,
but will be pushed out soon.)

thanks,

greg k-h
