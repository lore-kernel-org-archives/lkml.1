Return-Path: <linux-kernel-owner+w=401wt.eu-S1754639Ab0A1GZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab0A1GZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 01:25:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754344Ab0A1GZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 01:25:51 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52426 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab0A1GZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 01:25:51 -0500
Date: Thu, 28 Jan 2010 07:11:22 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
       Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz, zaurus-devel@www.linuxtogo.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: spitz (arm pda): time no longer ok after resume
Message-ID: <20100128061121.GA15937@ucw.cz>
References: <20100127171308.GA24875@ucw.cz> <20100127180010.GA22660@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100127180010.GA22660@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2010-01-27 18:00:10, Russell King - ARM Linux wrote:
> On Wed, Jan 27, 2010 at 06:13:08PM +0100, Pavel Machek wrote:
> > It seems that spitz has problems with time after resume; time while it
> > was sleeping is not accounted. This seems to be regression in
> > 2.6.33-rc5.
> 
> No rtc configured/loaded?

I did make oldconfig and it worked before... strange.

.config:
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set

It looks you are right, pxa-rtc.o was not there. Sorry.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
