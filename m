Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbYJ2RiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbYJ2RiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 13:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbYJ2RiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 13:38:10 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:17165 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbYJ2RiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 13:38:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CvwlI5KSBUunXjdNZrf3uZHp4s+pWMNZl561gzZWdBtFN28TaRPITfXozObd7etZJK
         uY4jyTCI2DirRQNWDn1G9M2gxA9m82m3OCWjRWWdshGHtBnRBpcvPWdWOODS60sz6+/2
         WQdwZZUTraHZnUQOri52rdZ9B2BW0NiNbb32Q=
Date: Wed, 29 Oct 2008 12:37:19 -0500
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: David Schleef <ds@schleef.org>,
       Frank Mori Hess <fmhess@users.sourceforge.net>,
       Ian Abbott <abbotti@mev.co.uk>, linux-kernel@vger.kernel.org,
       Wolfgang Beiter <w.beiter@aon.at>
Subject: Re: staging: me4000 and relation to other data acquisition devices
Message-ID: <20081029173719.GB5630@mediacenter>
References: <20081028154918.GA5630@mediacenter> <20081028163456.GA4278@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081028163456.GA4278@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 09:34:56AM -0700, Greg KH wrote:
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

I think that is up to the Comedi maintainers.  If the Comedi maintainers
do not want to head in that direction, I'm sure the me4000 driver
currently in drivers/staging/ would benefit from their review.

--
Shawn
