Return-Path: <linux-kernel-owner+w=401wt.eu-S1759133AbZAMNFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759133AbZAMNFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756172AbZAMNFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:05:38 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39201 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089AbZAMNFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:05:37 -0500
Date: Tue, 13 Jan 2009 14:05:36 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: kernel list <linux-kernel@vger.kernel.org>, harvey.harrison@gmail.com
Subject: Re: 2.6.29-rc1: thinkpad problems during resume
Message-ID: <20090113130536.GB30352@atrey.karlin.mff.cuni.cz>
References: <20090113081316.GA2292@elf.ucw.cz> <200901131239.21995.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901131239.21995.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Tuesday 13 January 2009, Pavel Machek wrote:
> > Hi!
> > 
> > Just when I thought long merge window means less problems...
> > 
> > ...suspend seemed to work until last tuesday or so. Now it hanged two
> > times; once so hard that power button powercycle did not result in
> > booting machine. (thinkpad x60)
> > 
> > I'll do some more tests...
> 
> There are a couple of things you may want to revert, like
> 7503bfbae89eba07b46441a5d1594647f6b8ab7d and
> a0d4922da2e4ccb0973095d8d29f36f6b1b5f703 .
> 
> Please let me know if that helped.

Harwey told me they are already reverted in latest -git, so I tried
that but no luck. I'll try disabling CONFIG_SMP now.

Actually, in one case I seen some oopses scroll by... looked
timekeeping related, but certainly went too fast.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
