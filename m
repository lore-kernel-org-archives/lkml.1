Return-Path: <linux-kernel-owner+w=401wt.eu-S1751719AbZHAReW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719AbZHAReW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 13:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbZHAReV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 13:34:21 -0400
Received: from kroah.org ([198.145.64.141]:59861 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbZHAReR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 13:34:17 -0400
Date: Sat, 1 Aug 2009 10:18:15 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: tty tree change for linux-next
Message-ID: <20090801171815.GA15259@kroah.com>
References: <20090801043905.GA12779@kroah.com>
 <20090801164104.5e9b2f17.sfr@canb.auug.org.au>
 <20090801172245.1d3e8b31.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090801172245.1d3e8b31.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 01, 2009 at 05:22:45PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Sat, 1 Aug 2009 16:41:04 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > On Fri, 31 Jul 2009 21:39:05 -0700 Greg KH <greg@kroah.com> wrote:
> > >
> > > If there are any problems with the trees, please let me know.
> > 
> > Will do.
> 
> Just a small (but important) thing.  All the tty series patches look like this:
> 
> <summary>
> 
> From: <author>
> 
> <message>
> .
> .
> 
> 
> When I import these, they will all look like they are authored by you and
> use the file name as the one line summary :-( .  "Git quilt-import"
> expects more mail-like patches like:
> 
> From: <author>
> Subject: <summary>
> 
> ..
> 
> So if there is some easy transform you could do on these, it would be
> good.  (There is only one patch that has "Subject:" at the start of the
> <summary>.)  (Subject: followed by From: is ok as well, so 'prepend
> "Subject: " to first line and remove following blank line' would probably
> get you very close.)

Ok, that's not good at all, I just took the patches straight from Alan.
I'll edit them up this weekend to work better (i.e. in the format that
all of my other patches are in, pseudo-mbox headers, which both quilt
and git seem to like.)

Thanks for letting me know,

greg k-h
