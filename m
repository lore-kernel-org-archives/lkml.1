Return-Path: <linux-kernel-owner+w=401wt.eu-S934114AbXKOWhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934114AbXKOWhG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 17:37:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762230AbXKOWgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 17:36:55 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:34545 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761242AbXKOWgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 17:36:53 -0500
Date: Thu, 15 Nov 2007 23:37:16 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: rusty@rustycorp.com.au, vatsa@in.ibm.com, zwane@arm.linux.org.uk,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: cpu hotplug strangeness in 2.6.24-rc2 (was Re: cpu hotplug support
	broken in 2.6.23-rc3)
Message-ID: <20071115223716.GA8446@elf.ucw.cz>
References: <20070827104350.GA2073@elf.ucw.cz> <20070829080827.GD6832@in.ibm.com> <20070903035854.GD3655@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070903035854.GD3655@ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Plus I guess it would be nice to add CPU HOTPLUG into MAINTAINERS
> > > file:
> > > 
> > 
> > There is a list of maintainers in the Documentation/cpu-hotplug.txt, 
> > which includes maintainers for different platforms as well.
> > 
> > It's a good idea to add that info to the MAINTAINERS file as well.
> 
> Yes, please.

Just an update... In 2.6.24-rc2, cpu hotplug basically works, _but_:

if I do echo 0 > online; echo 0 > online; at same cpu, I get error,
and can't up anything any more. It is not serious, but it is not
pretty, either.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
