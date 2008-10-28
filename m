Return-Path: <linux-kernel-owner+w=401wt.eu-S1753873AbYJ1Q5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbYJ1Q5w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 12:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbYJ1Q5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 12:57:43 -0400
Received: from ns2.suse.de ([195.135.220.15]:38405 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229AbYJ1Q5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 12:57:42 -0400
Date: Tue, 28 Oct 2008 09:34:56 -0700
From: Greg KH <gregkh@suse.de>
To: Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: David Schleef <ds@schleef.org>,
       Frank Mori Hess <fmhess@users.sourceforge.net>,
       Ian Abbott <abbotti@mev.co.uk>, linux-kernel@vger.kernel.org,
       Wolfgang Beiter <w.beiter@aon.at>,
       Guenter Gebhardt <g.gebhardt@meilhaus.de>
Subject: Re: staging: me4000 and relation to other data acquisition devices
Message-ID: <20081028163456.GA4278@suse.de>
References: <20081028154918.GA5630@mediacenter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081028154918.GA5630@mediacenter>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 10:49:18AM -0500, Shawn Bohrer wrote:
> I have some questions about the user-kernel interface of the me4000
> driver.  From my looking through the code it seems specific to the
> me4000 hardware which does concern me since there are hundreds of
> different data acquisition devices from many different vendors.  In my
> opinion it would beneficial if at the very least all of these devices
> shared a common device interface.

I totally agree.

The me4000's user interface is not "set in stone" and needs to be fixed
up in order to move into the main kernel tree.

> Additionally there is the out of tree Comedi project:
> 
> http://comedi.org
> 
> Which supports this hardware, and many more, with a generic device
> interface.  There may be other reason not to merge Comedi (I know they
> have a desire to maintain support of their RT support), but I can't help
> but feel that merging the me4000 driver without thinking about the
> hundreds of other devices out there is a mistake.

I would love to get comedi into the kernel tree.  People have talked
about it for years now, is it time for me to just take a snapshot and
place it in drivers/staging/ for everyone to then work on cleaning up
properly?

thanks,

greg k-h
