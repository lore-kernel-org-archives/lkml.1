Return-Path: <linux-kernel-owner+w=401wt.eu-S1760777AbZFIWJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760777AbZFIWJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 18:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753711AbZFIWJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 18:09:47 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44442 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbZFIWJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 18:09:46 -0400
Date: Wed, 10 Jun 2009 00:09:42 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Stanislav Brabec <utx@penguin.cz>
Cc: Eric Miao <eric.y.miao@gmail.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@opfer-online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com
Subject: Re: zaurus needs generic pxa suspend/resume routines
Message-ID: <20090609220942.GA13231@elf.ucw.cz>
References: <20090605131625.GC1376@ucw.cz> <20090607152152.GA7785@n2100.arm.linux.org.uk> <f17812d70906072358i69b4ce09oeb6cd455277b050f@mail.gmail.com> <20090608161929.GD32140@n2100.arm.linux.org.uk> <f17812d70906081843x6731898fl35252664e5a580a1@mail.gmail.com> <1244544600.9997.8.camel@hammer.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244544600.9997.8.camel@hammer.suse.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-06-09 12:50:00, Stanislav Brabec wrote:
> Eric Miao wrote:
> 
> > >> Yes, I think this is the best trade-off for the moment.
> > >>
> > >> Acked-by: Eric Miao <eric.miao@marvell.com>
> > >>
> 
> However resume still does not work with this patch on top of yesterday's
> Linus tree snapshot (SL-C3200, ccc0d38). It seems to go to resume for
> ~300 milliseconds (orange LED lights for a moment, power consumption
> increases) and then runs back to the sleep. It seems that it disables
> offline charging, too. When battery cover switch is open it goes to
> resume just for ~50 milliseconds (orange LED does not light).

Yes, the patch fixes just the "cpu registers not set correctly"
problem. Problem with charging remains. Unfortunately, I do have
patch to fix that, yet. (Yes, it can be worked around by disabling
offline charge, but that is not a fix).

> The last Pavel's hack from last week at least fixed resume at cost of
> breaking offline charging (and broken serial after resume).

Hmm, do you have a serial cable? :-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
