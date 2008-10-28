Return-Path: <linux-kernel-owner+w=401wt.eu-S1754026AbYJ1ReG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbYJ1ReG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 13:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752745AbYJ1Rdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 13:33:54 -0400
Received: from xenotime.net ([72.52.64.118]:39064 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752418AbYJ1Rdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 13:33:53 -0400
Date: Tue, 28 Oct 2008 10:33:37 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Greg KH <gregkh@suse.de>
Cc: Shawn Bohrer <shawn.bohrer@gmail.com>, David Schleef <ds@schleef.org>,
       Frank Mori Hess <fmhess@users.sourceforge.net>,
       Ian Abbott <abbotti@mev.co.uk>, linux-kernel@vger.kernel.org,
       Wolfgang Beiter <w.beiter@aon.at>,
       Guenter Gebhardt <g.gebhardt@meilhaus.de>
Subject: Re: staging: me4000 and relation to other data acquisition devices
Message-Id: <20081028103337.a021e85d.rdunlap@xenotime.net>
In-Reply-To: <20081028163456.GA4278@suse.de>
References: <20081028154918.GA5630@mediacenter>
	<20081028163456.GA4278@suse.de>
Organization: YPO4
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2008 09:34:56 -0700 Greg KH wrote:

> On Tue, Oct 28, 2008 at 10:49:18AM -0500, Shawn Bohrer wrote:
> > I have some questions about the user-kernel interface of the me4000
> > driver.  From my looking through the code it seems specific to the
> > me4000 hardware which does concern me since there are hundreds of
> > different data acquisition devices from many different vendors.  In my
> > opinion it would beneficial if at the very least all of these devices
> > shared a common device interface.
> 
> I totally agree.
> 
> The me4000's user interface is not "set in stone" and needs to be fixed
> up in order to move into the main kernel tree.
> 
> > Additionally there is the out of tree Comedi project:
> > 
> > http://comedi.org
> > 
> > Which supports this hardware, and many more, with a generic device
> > interface.  There may be other reason not to merge Comedi (I know they
> > have a desire to maintain support of their RT support), but I can't help
> > but feel that merging the me4000 driver without thinking about the
> > hundreds of other devices out there is a mistake.
> 
> I would love to get comedi into the kernel tree.  People have talked
> about it for years now, is it time for me to just take a snapshot and
> place it in drivers/staging/ for everyone to then work on cleaning up
> properly?

Greg,

Maybe I missed it at the beginning of the staging tree, but would you
explain which drivers you will or will not put into the staging tree?

E.g., what if someone doesn't want their driver merged into mainline?

---
~Randy
