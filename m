Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852AbYC0Xie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbYC0Xie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 19:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbYC0XiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 19:38:24 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33811 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbYC0XiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 19:38:23 -0400
Date: Fri, 28 Mar 2008 00:38:52 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: what's the incompatibility between hibernation and
	hotplug?memory
Message-ID: <20080327233852.GA32617@elf.ucw.cz>
References: <47EAD9A7.6020609@goop.org> <20080327084936.GD25876@elf.ucw.cz> <47EC0842.3020109@goop.org> <200803272155.01463.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803272155.01463.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-03-27 21:55:01, Rafael J. Wysocki wrote:
> On Thursday, 27 of March 2008, Jeremy Fitzhardinge wrote:
> > Pavel Machek wrote:
> > > Hi!
> > >
> > >   
> > >>> I noticed that Kconfig warns that hibernation and hotplug memory are not 
> > >>> compatible.  What's the issue?
> > >>>       
> > >> Generally, we might not be able to handle memory unplugged at a wrong time
> > >> (eg. after we've created the image).
> > >>
> > >> Which part of Kconfig says that exactly?
> > >>     
> > >
> > > Actually I believe it is simpler than that. We were not prepared to
> > > deal with memory holes in hibernation code, so we just disabled it in
> > > Kconfig...
> > 
> > Doesn't that mean its generally incompatible with non-flatmem memory 
> > arrangements rather than hotplug memory specifically?
> 
> No, it should work with NUMA nowadays, actually.
> 
> Perhaps it's worth trying it with hotplug memory and see what problems arise?

Good. I believe it is good chance it will work with hotplug, too... as
long as memory is not inserted/removed during suspend/resume.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
