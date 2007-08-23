Return-Path: <linux-kernel-owner+w=401wt.eu-S1762102AbXHWK0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762102AbXHWK0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 06:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759922AbXHWK0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 06:26:35 -0400
Received: from thunk.org ([69.25.196.29]:53352 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759830AbXHWK0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 06:26:34 -0400
Date: Thu, 23 Aug 2007 06:26:30 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Richard Ballantyne <richardballantyne@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: file system for solid state disks
Message-ID: <20070823102630.GH7267@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	Richard Ballantyne <richardballantyne@gmail.com>,
	linux-kernel@vger.kernel.org
References: <46CD14A6.4050605@gmail.com> <Pine.LNX.4.64.0708230746140.12788@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708230746140.12788@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2007 at 07:52:46AM +0200, Jan Engelhardt wrote:
> 
> On Aug 23 2007 01:01, Richard Ballantyne wrote:
> >
> >What file system that is already in the linux kernel do people recommend
> >I use for my laptop that now contains a solid state disk?
> 
> If I had to choose, the list of options seems to be:
> 
> - logfs
>   [unmerged]
> 
> - UBI layer with any fs you like
>   [just a guess]

The question is whether the solid state disk gives you access to the
raw flash, or whether you have to go through the flash translation
layer because it's trying to look (exclusively) like a PATA or SATA
drive.  There are some SSD's that have a form factor and interfaces
that make them a drop-in replacement for a laptop hard drive, and a
number of the newer laptops that are supporting SSD's seem to be these
because (a) they don't have to radically change their design, (b) so
they can be compatible with Windows, and (c) so that users can
purchase the laptop either with a traditional hard drive or a SSD's as
an option, since at the moment SSD's are far more expensive than
disks.

So if you can't get access to the raw flash layer, then what you're
probably going to be looking at is a traditional block-oriented
filesystem, such as ext3, although there are clearly some things that
could be done such as disabling the elevator.   
      
						- Ted
