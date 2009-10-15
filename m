Return-Path: <linux-kernel-owner+w=401wt.eu-S935414AbZJOVxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935414AbZJOVxB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 17:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935347AbZJOVxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 17:53:01 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34432 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935320AbZJOVxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 17:53:00 -0400
Date: Thu, 15 Oct 2009 23:52:15 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Stanislav Brabec <utx@penguin.cz>
Cc: Eric Miao <eric.y.miao@gmail.com>, Andrew Morton <akpm@osdl.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@opfer-online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com
Subject: Re: spitz: add gpio button support (fixes regression)
Message-ID: <20091015215215.GG15898@elf.ucw.cz>
References: <20091006074635.GA2775@ucw.cz>
 <1254829732.3546.35.camel@utx.utx.cz>
 <20091007085806.GB28807@elf.ucw.cz>
 <1254914991.4213.80.camel@hammer.suse.cz>
 <20091007120643.GA17069@rakim.wolfsonmicro.main>
 <f17812d70910070727x47b2a22h8e9f9304740d5abf@mail.gmail.com>
 <20091006200933.GA1606@ucw.cz>
 <1255641385.3985.55.camel@utx.utx.cz>
 <20091015212024.GC15898@elf.ucw.cz>
 <1255643252.3985.63.camel@utx.utx.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255643252.3985.63.camel@utx.utx.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-10-15 23:47:32, Stanislav Brabec wrote:
> Pavel Machek wrote:
> >Well, resume is hit by second regression.
> >
> >Suspend key.... I restored it to the level of functionality in
> >2.6.31 :-).
> 
> > > +		.type	= EV_KEY,
> > > +		.code	= KEY_SUSPEND,
> 
> I guess it should be EV_PWR. Then it will at least go to suspend.

Does it actually go to suspend with that change?

(Actually, I wonder how it could have ever worked: userspace should
certainly be in a loop there; kernel should not suspend machine on its
own. In -rp kernels, kernel _does_ suspend on its own, but... I'm not
sure if that's suitable for mainline).
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
