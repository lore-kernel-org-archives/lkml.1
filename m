Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab0CHH3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 02:29:09 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:49626 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751527Ab0CHH3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 02:29:00 -0500
Date: Mon, 8 Mar 2010 08:28:59 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz,
       zaurus-devel@www.linuxtogo.org
Subject: Re: bit errors on spitz
Message-ID: <20100308072858.GA29939@atrey.karlin.mff.cuni.cz>
References: <20100305212708.GC21773@elf.ucw.cz> <f17812d71003072137u51be17a1ie3e50e30dea16f77@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f17812d71003072137u51be17a1ie3e50e30dea16f77@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, Mar 6, 2010 at 5:27 AM, Pavel Machek <pavel@ucw.cz> wrote:
> > Hi!
> >
> > I'm getting way too many bit errors on spitz, with various
> > kernels.
> >
> > It may be tied to network usage (bluetooth or wifi?). It happens even
> > on AC power.
> 
> Pavel,
> 
> What kind of bit errors? I'm not using any network here on my spitz so
> not sure what exactly was happening. Could you paste the dmesg here
> so we can help take a look?

dmesg would not be useful, it usually hits user programs. Like... mutt
suddenly displaying , instead of - in the header. Program failing to
start because function printg is not found (it was not exactly
printf->printg,  I don't remember exact symbol), ping complaining
about discarding corrupted packets, etc.

(Or of course, kernel oopsing or not going from suspend at all. But as
even user data are being corrupted, oops is not likely to be
interesting and system is typically not in state to capture it any more.)

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
