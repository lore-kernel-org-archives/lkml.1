Return-Path: <linux-kernel-owner+w=401wt.eu-S1030591AbXD1BEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030591AbXD1BEb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 21:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030608AbXD1BEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 21:04:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59484 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030591AbXD1BEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 21:04:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: Back to the future.
Date: Sat, 28 Apr 2007 03:08:53 +0200
User-Agent: KMail/1.9.5
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       LKML <linux-kernel@vger.kernel.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <463292C8.9000307@goop.org> <20070428010043.GA21136@srcf.ucam.org>
In-Reply-To: <20070428010043.GA21136@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704280308.54398.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 28 April 2007 03:00, Matthew Garrett wrote:
> On Fri, Apr 27, 2007 at 05:18:16PM -0700, Jeremy Fitzhardinge wrote:
> 
> > Then you could use kexec for resume...
> 
> While that would certainly be nifty, I think we're arguably starting 
> from the wrong point here. Why are we booting a kernel, trying to poke 
> the hardware back into some sort of mock-quiescent state, freeing memory 
> and then (finally) overwriting the entire contents of RAM rather than 
> just doing all of this from the bootloader? Given the time spent in 
> kernel setup and unpacking initramfs nowadays, I'm willing to bet it'd 
> still be faster even if you're stuck using int 13 on x86.

Yes, that would be faster.

> http://apcmag.com/5873/page14 suggests that Intel is looking into this, 
> but I haven't heard anything more yet. To the best of my knowledge, this 
> is also how Windows manages things.

I think you're right.

Greetings,
Rafael
