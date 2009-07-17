Return-Path: <linux-kernel-owner+w=401wt.eu-S933924AbZGQBMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933924AbZGQBMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 21:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933909AbZGQBMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 21:12:53 -0400
Received: from kroah.org ([198.145.64.141]:34226 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933805AbZGQBMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 21:12:52 -0400
Date: Thu, 16 Jul 2009 18:12:11 -0700
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: swetland@google.com, malchev@google.com,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: HTC Dream: qdsp support for staging
Message-ID: <20090717011211.GA16704@kroah.com>
References: <20090710083709.GA6418@elf.ucw.cz>
 <20090716230042.GB3609@kroah.com>
 <20090717010157.GA2002@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090717010157.GA2002@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 17, 2009 at 03:01:57AM +0200, Pavel Machek wrote:
> On Thu 2009-07-16 16:00:42, Greg KH wrote:
> > On Fri, Jul 10, 2009 at 10:37:10AM +0200, Pavel Machek wrote:
> > > From: Iliyan Malchev <ibm@android.com>
> > > 
> > > QDSP code is neccessarry for communication with some hardware
> > > components on HTC Dream, including camera hardware. It also drives DSP
> > > coproccessor.
> > > 
> > > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > 
> > Please don't compress patches :(
> 
> I had to -- in order to fit to lkml maillist limits.

I have no such limits :)

> > Your patch didn't have any way to actually build the code, care to
> > respin it and add the proper Kconfig and Makefile hooks?
> 
> Well, resending 100K+ patch to get 3 missing lines is somewhat
> "interesting"... and the problem is that proper Kconfig/Makefile hooks
> actually depend on order in which you apply the patches.
> 
> Would it be possible to just apply the 3 patches, with me supplying
> Kconfig/Makefile hooks in patch #4? That's sometimes used to
> aid bisectability, and it would save me quite a lot of work (and
> possible mistakes) that way.

Yes, that would be fine.  Care to send all 4, I've purged the old ones
from my queue.

thanks,

greg k-h
