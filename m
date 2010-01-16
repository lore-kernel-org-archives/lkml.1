Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab0APSNL (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 13:13:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755846Ab0APSNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 13:13:08 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34709 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854Ab0APSNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 13:13:02 -0500
Date: Sat, 16 Jan 2010 19:12:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Stanislav Brabec <utx@penguin.cz>
Cc: Eric Miao <eric.y.miao@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Bart?omiej Zimo? <uzi18@o2.pl>, Andy Walls <awalls@radix.net>,
        Daniel Borkmann <danborkmann@googlemail.com>,
        linux-kernel@vger.kernel.org, rpurdie@rpsys.net, lenz@cs.wisc.edu,
        Dirk@opfer-online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
        thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com,
        zaurus-devel@www.linuxtogo.org
Subject: Re: [suspend/resume] Re: userspace notification from module
Message-ID: <20100116181253.GC1603@ucw.cz>
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl> <201001091440.46434.rjw@sisk.pl> <20100115200310.GG1345@ucw.cz> <201001152314.30355.rjw@sisk.pl> <f17812d71001151900x35959e88jc5f275573ee02177@mail.gmail.com> <1263661258.6596.10.camel@utx.utx.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263661258.6596.10.camel@utx.utx.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2010-01-16 18:00:58, Stanislav Brabec wrote:
> Eric Miao wrote:
> 
> > And the other way we may need to look into what API the current userland
> > apps on zaurus is depending on this 2.4 compatibility and make changes
> > slowly to those apps.
> 
> I guess that 2.4 compatibility is not an issue. Most modern Zaurus
> distributions are even unable to run Sharp ROM compatible binaries.
> 
> Distributions either stay on 2.4 kernel or use modern systems based on
> modern kernel 2.6 API.
> 
> Distributions that decided to migrate to kernel 2.6 are far from
> finished state. Any change that allows to use modern applications using
> standard kernel API is welcome.

There is no API involved. It is just ... if you leave zaurus in
 init=/bin/bash mode, it must not kill the battery. Smart and
 currently implemented way to do that is to suspend.

That's counterexample to rjw, but it does not matter -- reasonable
userland should never ever hit that, in a same way PCs should not hit
emergency power cut...
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
