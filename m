Return-Path: <linux-kernel-owner+w=401wt.eu-S1757977AbYAZAl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977AbYAZAl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 19:41:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbYAZAlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 19:41:49 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:52232 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbYAZAls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 19:41:48 -0500
Subject: Re: [GIT PATCH] driver core patches against 2.6.24
From: Jon Masters <jonathan@jonmasters.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1201307242.27573.13.camel@lappy>
References: <20080125071127.GA4860@kroah.com>
	 <alpine.LFD.1.00.0801251035150.2979@hp.linux-foundation.org>
	 <20080125185213.GA23475@suse.de>
	 <alpine.LFD.1.00.0801251108480.2979@hp.linux-foundation.org>
	 <479A3ED3.6020808@goop.org> <1201296027.32422.80.camel@perihelion>
	 <alpine.LFD.1.00.0801251347010.5056@hp.linux-foundation.org>
	 <479A5B72.6080701@goop.org> <1201299979.27573.11.camel@lappy>
	 <20080126000526.GA24559@elte.hu>  <1201307242.27573.13.camel@lappy>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Fri, 25 Jan 2008 19:40:53 -0500
Message-Id: <1201308053.32422.92.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-01-26 at 01:27 +0100, Peter Zijlstra wrote:
> On Sat, 2008-01-26 at 01:05 +0100, Ingo Molnar wrote:
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > 
> > > My wish is that distros would just boot without requiring an initrd. I 
> > > know how to make them for redhat and debian based distros, but the 
> > > fact that you can't (easily) cross-build them makes it a very tedious 
> > > construct.
> > 
> > all it takes for me on Fedora is to boot a modular distro kernel once, 
> > then copy the /dev to the real (persistent) /dev:
> > 
> >    mkdir /tmp2
> >    mount /dev/sda1 /tmp2
> >    cp -a /dev/* /tmp2/dev/
> > 
> > and from that point on a bzImage/vmlinuz can boot up on Fedora without 
> > any problems (as long as it has the right drivers built in), and the 
> > initrd line can be removed from grub.conf.
> 
> Yeah, I usually do the same but with a bind mount, still it would be
> grand if such things would not be needed.

Agreed. But it's not likely to be a priority - all the vendors want
completely modular kernels. But now we see what Linus wants to do,
perhaps we can try to be a bit more friendly toward that. It's not
actually rocket science, after all. I was concerned that he wanted to
use the modules in the initrd, but now I see Linus, and everyone else,
just want to do what I also secretly do, and just not use an initrd.

Isn't it funny. We all secretly hate using initrds ourselves :)

Jon.


