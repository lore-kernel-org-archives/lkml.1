Return-Path: <linux-kernel-owner+w=401wt.eu-S1757071AbXFUNU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071AbXFUNU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 09:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755296AbXFUNUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 09:20:20 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39706 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755292AbXFUNUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 09:20:19 -0400
Date: Thu, 21 Jun 2007 15:20:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Stefan Seyfried <seife@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, nigel@nigel.suspend2.net,
       linux-kernel@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       akpm@linux-foundation.org
Subject: Re: [Suspend-devel] [PATCH, 3rd try] make disable_console_suspend runtime configurable
Message-ID: <20070621132008.GE18392@elf.ucw.cz>
References: <20070613200303.GB11437@suse.de> <200706141414.22152.rjw@sisk.pl> <200706141559.54242.fseidel@suse.de> <200706150020.29189.rjw@sisk.pl> <20070617213530.GE1803@elf.ucw.cz> <20070617214940.GA1951@elf.ucw.cz> <20070618052747.GA15173@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618052747.GA15173@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Sorry for not screaming when CONFIG_DISABLE_CONSOLE_SUSPEND went in,
> > > but please lets solve this correctly....
> > 
> > Ouch and sorry for not screaming at "try 1" time. But it still does
> > not make the patch right, and I believe that even patch authors agree
> > that "no-config-needed" is superior solution.
> 
> No, i don't agree at all.
> 
> In this case, "no config needed" == "not possible to debug suspend
> problems".

No, sorry.

My proposed solution is "figure out which console drivers can survive
being on while machines go down, and keep them on".

So, "no config needed" == "kernel always does the right thing, keeping
console during suspend when possible" == "possible to debug suspend
problems without having to change CONFIG_ or /sys/*".

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
