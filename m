Return-Path: <linux-kernel-owner+w=401wt.eu-S932815AbYDVVGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815AbYDVVGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 17:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757514AbYDVVGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 17:06:41 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:61289 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742AbYDVVGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 17:06:40 -0400
Message-ID: <8411091.1208898374115.JavaMail.oracle@acsmt302.oracle.com>
Date: Tue, 22 Apr 2008 16:06:14 -0500 (CDT)
From: Randy Dunlap <RANDY.DUNLAP@ORACLE.COM>
To: "Randy.Dunlap" <rdunlap@xenotime.net>,
       Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH] mfd: kconfig exposing unbuildable driver
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080422210153.GB21435@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
References: <1208895950.24124.9.camel@brick> <20080422203334.GA9809@flint.arm.linux.org.uk> <Pine.LNX.4.64.0804221337550.19817@shark.he.net> <20080422204549.GA21435@flint.arm.linux.org.uk> <Pine.LNX.4.64.0804221346470.19817@shark.he.net> <20080422210153.GB21435@flint.arm.linux.org.uk>
X-Priority: 3
X-Mailer: Oracle Webmail Client(UIX)
Content-Language: en-US
Accept-Language: en-US
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Original Message --- (from rmk:)
> On Tue, Apr 22, 2008 at 01:47:18PM -0700, Randy.Dunlap wrote:
> > On Tue, 22 Apr 2008, Russell King wrote:
> > > On Tue, Apr 22, 2008 at 01:38:28PM -0700, Randy.Dunlap wrote:
> > > > On Tue, 22 Apr 2008, Russell King wrote:
> > > > 
> > > > > That was my initial approach as well, which got shot down by Andrew
> > > > > Morton and others as being unacceptable.
> > > > 
> > > > where?
> > > 
> > > In private mail.
> > > 
> > > > why?
> > > 
> > > Well, first I need to gain the permission of Andrew to post his private
> > > message.  I'm not being subborn here - I _do_ _not_ reproduce private
> > > messages in public without prior permission.
> > 
> > Sure, understood.
> > 
> > > > Seems like we need to push back on that part.
> > > 
> > > Talk to Andrew then.
> > 
> > He is cc-ed (although traveling much this week IIRC).
> 
> In which case, since it's likely I won't get a reply in the
> next hour
> (which'll delay my response by 24 hours) let me paraphrase
> what Andrew said.
> 
> Andrew believes that it is beneficial to have other architectures,
> particularly x86, build other architectures drivers.

Sure.

> Meanwhile, pHilipp Zabel believes this hardware not to be ARM
> specific.

That's the big Important missing info.  So the source file is
incorrect, not the Kconfig.l

> So, the majority concensus in the three way discussion was
> that it
> should remain visible, and the (unnecessary) include and its
> dependents be removed.
> 
> Having now had some time (read: half an hour after dinner after
> getting
> back home) to investigate, I can point to the patch in several
> places:
> 
>   http://ftp.arm.linux.org.uk/pub/armlinux/kernel/git-cur/arm:devel.mbox
> 
> and find the patch with subject line:
> 
>   [ARM] 5010/1: htc-pasic3: remove unused defines and includes
> 
> or grab 5010/1 from my patch system.  If you want a patch to
> plaster over it, merging that would be a far better solution.

OK, sounds fair.  Thanks.

~Randy

