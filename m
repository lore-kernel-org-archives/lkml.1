Return-Path: <linux-kernel-owner+w=401wt.eu-S1752043AbZJPJ3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbZJPJ3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 05:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbZJPJ3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 05:29:17 -0400
Received: from ns.penguin.cz ([84.21.108.25]:33453 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbZJPJ3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 05:29:16 -0400
Subject: Re: spitz: add gpio button support (fixes regression)
From: Stanislav Brabec <utx@penguin.cz>
To: Pavel Machek <pavel@ucw.cz>
Cc: Eric Miao <eric.y.miao@gmail.com>, Andrew Morton <akpm@osdl.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@opfer-online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com
In-Reply-To: <20091015215215.GG15898@elf.ucw.cz>
References: <20091006074635.GA2775@ucw.cz>
	 <1254829732.3546.35.camel@utx.utx.cz> <20091007085806.GB28807@elf.ucw.cz>
	 <1254914991.4213.80.camel@hammer.suse.cz>
	 <20091007120643.GA17069@rakim.wolfsonmicro.main>
	 <f17812d70910070727x47b2a22h8e9f9304740d5abf@mail.gmail.com>
	 <20091006200933.GA1606@ucw.cz> <1255641385.3985.55.camel@utx.utx.cz>
	 <20091015212024.GC15898@elf.ucw.cz> <1255643252.3985.63.camel@utx.utx.cz>
	 <20091015215215.GG15898@elf.ucw.cz>
Content-Type: text/plain; charset="ISO-8859-2"
Date: Fri, 16 Oct 2009 11:28:35 +0200
Message-Id: <1255685315.5470.3.camel@hammer.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Thu 2009-10-15 23:47:32, Stanislav Brabec wrote:
> > Pavel Machek wrote:
> > >Well, resume is hit by second regression.
> > >
> > >Suspend key.... I restored it to the level of functionality in
> > >2.6.31 :-).
> > 
> > > > +		.type	= EV_KEY,
> > > > +		.code	= KEY_SUSPEND,
> > 
> > I guess it should be EV_PWR. Then it will at least go to suspend.
> 
> Does it actually go to suspend with that change?

Yes.

> (Actually, I wonder how it could have ever worked: userspace should
> certainly be in a loop there; kernel should not suspend machine on its
> own. In -rp kernels, kernel _does_ suspend on its own, but... I'm not
> sure if that's suitable for mainline).

At least userspace apmd should be able to enter into suspend process
(tested in 2.6.26-RP, not yet verified in 2.6.32-rc*).

I don't know, what is the preferred way in recent days, but Tosa does
the same.

-- 
Best Regards / S pozdravem,

Stanislav Brabec
software developer
---------------------------------------------------------------------
SUSE LINUX, s. r. o.                          e-mail: sbrabec@suse.cz
Lihovarská 1060/12           tel: +420 284 028 966, +49 911 740538747
190 00 Praha 9                                  fax: +420 284 028 951
Czech Republic                                    http://www.suse.cz/

