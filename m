Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbZHHA4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbZHHA4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 20:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755283AbZHHA4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 20:56:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:52335 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755248AbZHHA4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 20:56:53 -0400
Date: Fri, 7 Aug 2009 17:41:56 -0700
From: Greg KH <gregkh@suse.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Andi Kleen <andi@firstfloor.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 3/5] tty: handle VT specific compat ioctls in vt driver
Message-ID: <20090808004156.GA23747@suse.de>
References: <1249564170-18627-1-git-send-email-arnd@arndb.de>
 <200908070904.11260.arnd@arndb.de>
 <20090807080428.GB4955@nowhere>
 <200908071402.11217.arnd@arndb.de>
 <20090808003451.GK4999@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090808003451.GK4999@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 08, 2009 at 02:34:53AM +0200, Frederic Weisbecker wrote:
> On Fri, Aug 07, 2009 at 02:02:11PM +0200, Arnd Bergmann wrote:
> > On Friday 07 August 2009, Frederic Weisbecker wrote:
> > > Ok. This looks like a nice series. A bkl pushdown that only goes down
> > > in one site among several others enlightens the understanding of what it
> > > is protecting (beside the nice fact it also burned three bkl callsites :-)
> > 
> > Thanks!
> > 
> > Well, most importantly patch 5/5 fixes a long-standing bug where we held
> > the BKL in lots of places that were already proven not to need it, or
> > alternatively held it twice (nested) in the ioctls that may still need it.
> > 
> > I did patch 3/5 this way because I read that you were working on BKL
> > removal for TTY and wanted to do my share by removing the dependency
> > on the code that I care about (fs/compat_ioctl.h).
> > 
> > 	Arnd <><
> 
> Thanks!
> 
> I guess these patches could fit in the tty tree, unless someone has
> objections?

I've taken this patch, I didn't see any others sent to me :(

thanks,

greg k-h
