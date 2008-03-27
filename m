Return-Path: <linux-kernel-owner+w=401wt.eu-S1759540AbYC0JbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759540AbYC0JbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 05:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbYC0JaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 05:30:23 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:53462 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbYC0JaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 05:30:21 -0400
Date: Thu, 27 Mar 2008 09:49:36 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: what's the incompatibility between hibernation and hotplug
	memory
Message-ID: <20080327084936.GD25876@elf.ucw.cz>
References: <47EAD9A7.6020609@goop.org> <200803270027.26037.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803270027.26037.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I noticed that Kconfig warns that hibernation and hotplug memory are not 
> > compatible.  What's the issue?
> 
> Generally, we might not be able to handle memory unplugged at a wrong time
> (eg. after we've created the image).
> 
> Which part of Kconfig says that exactly?

Actually I believe it is simpler than that. We were not prepared to
deal with memory holes in hibernation code, so we just disabled it in
Kconfig...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
