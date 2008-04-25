Return-Path: <linux-kernel-owner+w=401wt.eu-S1758761AbYDYLMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761AbYDYLMI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 07:12:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYDYLL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 07:11:57 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:52496 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbYDYLL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 07:11:56 -0400
Date: Fri, 25 Apr 2008 13:12:37 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "John W. Linville" <linville@tuxdriver.com>, cfarrell@suse.de
Cc: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com
Subject: Re: w35und: good news about licensing
Message-ID: <20080425111237.GA15479@elf.ucw.cz>
References: <20080414224740.GA31431@elf.ucw.cz> <20080415002826.GC4270@tuxdriver.com> <20080415070923.GA13767@elf.ucw.cz> <20080415132845.GA11789@tuxdriver.com> <20080415195603.GE4994@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415195603.GE4994@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Actually you are about month early to the party ;-). We are trying to
> > > clean up winbond usb wireless driver, so that it can think about
> > > inclusion in kernel.
> > > 
> > > http://code.google.com/p/winbondport/
> > > 
> > > Unfortunately, original driver carries its own 802.11 stack with it;
> > > that needs to be stripped down. (And then code needs to be rewritten
> > > due to horrible coding style).
> > 
> > I see...OK.
> > 
> > Did you get any legal advice regarding whether or not
> > MODULE_LICENSE("GPL") was sufficient to proclaim the driver as covered
> > by the GPL?
> 
> I dislike talking to lawyers, do not have any easily physically
> reachable, and believe the case is pretty clear...
> 
> ...plus, we plan to rewrite the driver, anyway...

Ok, so I did actually talk to a lawyer that happened to be nearby. We
did short analysis, and we believe that yes, w35und is under GPL. The
only problem is in wpa/ subdirectory where md5 (IIRC) is under RSA
license.

wpa/ subdirectory is already empty in my version, so we should be ok.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
