Return-Path: <linux-kernel-owner+w=401wt.eu-S932808AbZLKPtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808AbZLKPtK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 10:49:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758844AbZLKPtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 10:49:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48672 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758812AbZLKPtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 10:49:08 -0500
Date: Fri, 11 Dec 2009 07:36:00 -0800
From: Greg KH <gregkh@suse.de>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: David Brownell <david-b@pacbell.net>,
       "Nikula Jani.1 (EXT-Nixu/Helsinki)" <ext-jani.1.nikula@nokia.com>,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dsilvers@simtec.co.uk" <dsilvers@simtec.co.uk>,
       "ben@simtec.co.uk" <ben@simtec.co.uk>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] gpiolib: use chip->names for symlinks, always use
	gpioN for device names
Message-ID: <20091211153600.GD28097@suse.de>
References: <cover.1260364108.git.ext-jani.1.nikula@nokia.com> <200912101939.30446.david-b@pacbell.net> <20091211034711.GA2773@suse.de> <200912102013.59329.david-b@pacbell.net> <20091211043849.GA18007@suse.de> <1260509771.12346.138.camel@localhost> <20091211054614.GA23644@suse.de> <1260517894.12346.152.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260517894.12346.152.camel@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 09:51:34AM +0200, Artem Bityutskiy wrote:
> On Fri, 2009-12-11 at 06:46 +0100, ext Greg KH wrote:
> > > And no, we do not have per-gpio struct device, so we cannot add a new
> > > "name" attribute there. We need to either persuade you to accept our
> > > solution or make you take closer look at gpoiolib subsystem and suggest
> > > us the right way to go :-)
> > 
> > If you don't have a struct device, then what are you going to generate a
> > symlink to?
> 
> Sorry, this piece of information was wrong.

Great, then you can use the 'let's make a sysfs file and grep for it
from userspace' option.

Or, you can use the 'create a directory for your class, and create
symlinks in there like other subsystems do' option.

Both of which require no changes in the driver core, and have precedent
in that other subsystems already do this today.

Good luck,

greg k-h
