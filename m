Return-Path: <linux-kernel-owner+w=401wt.eu-S1753286AbYHGTG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbYHGTG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 15:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755451AbYHGTGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 15:06:18 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:57481 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbYHGTGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 15:06:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZGypsNgdthu5kZC6qknxcK5xEwV1CrOplTOrF99ojZlU6MNacaKeY/ReNqPXVTKpxr
         kg3WhZBGXh3Cny+CVgVXPRkfvN+N4qYWIiEOXG+tt6QIqE8bWggWaA5IakJljFj+kyt5
         HscLRkTAcQtjGzrtOfJaS25FkWtjxWBQfcFbk=
Date: Thu, 7 Aug 2008 15:06:10 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, rjw@sisk.pl, bzolnier@gmail.com,
       sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       stable@kernel.org
Subject: Re: linux-next: Tree for July 30
Message-ID: <20080807150231.ZZRA012@mailhub.coreip.homeip.net>
References: <20080731104437.5e5669bc.akpm@linux-foundation.org> <20080731141302.ZZRA012@mailhub.coreip.homeip.net> <200807312048.57575.rjw@sisk.pl> <20080731145023.ZZRA012@mailhub.coreip.homeip.net> <alpine.LFD.1.10.0807311207000.3277@nehalem.linux-foundation.org> <20080731151625.ZZRA012@mailhub.coreip.homeip.net> <20080731194207.GA12233@anvil.corenet.prv> <20080731131056.eecc4826.akpm@linux-foundation.org> <20080807140357.ZZRA012@mailhub.coreip.homeip.net> <20080807115031.6e136ecf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080807115031.6e136ecf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2008 at 11:50:31AM -0700, Andrew Morton wrote:
> On Thu, 7 Aug 2008 14:11:09 -0400
> Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> 
> > On Thu, Jul 31, 2008 at 01:10:56PM -0700, Andrew Morton wrote:
> > > 
> > > If that works then great.  But I think the printk could be improved. 
> > > Please provide sufficient information so that users (not programmers)
> > > can go off and fix things up without needing to email kernel developers.
> > > 
> > > One suitable approach would be
> > > 
> > > 	printk("see http://userweb.kernel.org/~dtor/read-this.txt")
> > > 
> > 
> > Ok, I made a small page here:
> > 
> > 	http://userweb.kernel.org/~dtor/eviocgbit-bug.html
> 
> You need to mv that file.  It's actually at
> http://userweb.kernel.org/~dtor/eviogcbit-bug.html
> 
> And
> 
>      evdev.c(EVIOCGBIT): Suspicious buffer size 511, limiting output to 64
>      bytes. See http://userweb.kernel.org/~dtor/eviocgbit-bug.html 
> 
> will get a 404.
> 

Fixed.

> typo: s/distribbution/distribution/
> 

Fixed.

> The text looks good.  A user would come away wondering which packages
> need to be updated.  Do we have a suitable text pattern whcih will help
> them?
> 
> On a fedora system I have
> 
> y:/home/akpm> rpm -qa|grep -i syna
> synaptics-0.14.6-2.fc8
> 
> So "the synaptics package" would be a suitably distro-neutral description.
> 

There is apparently Synaptic package manager - quite similar name - so
I want to emphasize that we are concerned with a driver for X.

> `rpm -qa|grep -i tslib' comes up blank so I don't know about that one.

This is a touchscreen library that is used by embedded people.
Unfortunately I have no idea where the authoritative source is.

> 
> > If you think this is sufficient I'd like to put the patch with the
> > warning in 2.6.27 so people and distributions could start updarting
> > affected programs.
> 
> Sure.  It'd make sense to get that warning into 2.6.25.x and 2.6.26.x
> as well, to accelerate the process a bit.
> 

Ok, good.

-- 
Dmitry
