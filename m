Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047AbZGLWPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbZGLWPX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 18:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbZGLWPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 18:15:11 -0400
Received: from kroah.org ([198.145.64.141]:55158 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420AbZGLWPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 18:15:10 -0400
Date: Sun, 12 Jul 2009 15:14:30 -0700
From: Greg KH <greg@kroah.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Siarhei Liakh <sliakh.lkml@gmail.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-cris-kernel@axis.com
Subject: Re: [PATCH v5] RO/NX protection for loadable kernel modules
Message-ID: <20090712221430.GA16151@kroah.com>
References: <817ecb6f0907081610p6d60341cudbee42685eac1347@mail.gmail.com>
 <200907121410.39874.rusty@rustcorp.com.au>
 <20090712004524.2f0c4e57@infradead.org>
 <200907121928.28887.rusty@rustcorp.com.au>
 <20090712083227.39939849@infradead.org>
 <20090712173329.GB12054@kroah.com>
 <20090712145804.2f1fce98@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090712145804.2f1fce98@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 12, 2009 at 02:58:04PM -0700, Arjan van de Ven wrote:
> On Sun, 12 Jul 2009 10:33:29 -0700
> Greg KH <greg@kroah.com> wrote:
> 
> > > 
> > > 105 is also a sign that you picked a somewhat suboptimal config...
> > > that's of course your choice but it's a choice that has a small
> > > price, if you don't want to pay that price, changing the config to
> > > not be entirely insane is a good answer as well ;-)
> > 
> > But this is the "common" case in the world of Linux where the distros
> > are forced to build everything as modules. 
> 
> who's holding the stick?
> Really.

Stick?

> I've seen some of these case, where the distro kernel has something as
> a module, but the other parts of the distro the unconditionally load
> that module always. That makes no sense.
> If you have 105 different real devices in your system, that have
> different drivers, sure, I'll buy 105. Somehow I doubt Rusty's box has
> 105 ;)

Sure, and I agree that some distros do modularize stuff too much, and am
personally changing this on a distro that I can change.  But even then,
I expect a "normal" system will end up with about 20-50 different
modules, due to a variety of good reasons (legacy system and ability to
handle wierd configurations better being both of them.)

thanks,

greg k-h
