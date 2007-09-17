Return-Path: <linux-kernel-owner+w=401wt.eu-S1759558AbXIQUvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759558AbXIQUvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 16:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756725AbXIQUvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 16:51:35 -0400
Received: from main.carme.maven.pl ([193.239.45.138]:13692 "EHLO
	main.carme.maven.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756583AbXIQUve convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 16:51:34 -0400
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Organization: SelfOrganizing
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [3/3] 2.6.23-rc6: known regressions v2
Date: Mon, 17 Sep 2007 22:51:06 +0200
User-Agent: PLD Linux KMail/1.9.7
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>,
       Thomas Voegtle <tv@lio96.de>, Soeren Sonnenburg <kernel@nn7.de>
References: <46EB3EF8.6040103@googlemail.com> <200709172144.43761.arekm@maven.pl> <1190058463.2995.14.camel@chaos>
In-Reply-To: <1190058463.2995.14.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709172251.07769.arekm@maven.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 of September 2007, Thomas Gleixner wrote:
> On Mon, 2007-09-17 at 21:44 +0200, Arkadiusz Miskiewicz wrote:
> > On Saturday 15 of September 2007, Rafael J. Wysocki wrote:
> > > On Saturday, 15 September 2007 04:29, Michal Piotrowski wrote:
> > > > Subject         : resume from ram much slower
> > > > References      : http://lkml.org/lkml/2007/8/10/275
> > > > Last known good : 2.6.23-rc1 ?
> > > > Submitter       : Arkadiusz Miskiewicz <arekm@maven.pl>
> > > > Caused-By       : ?
> > > > Handled-By      : Rafael J. Wysocki <rjw@sisk.pl>
> > > > Status          : problem is being debugged
> > >
> > > Unresolved, bisection might be helpful.
> >
> > Took 16 hours of bisecting and playing with stuff.
> >
> > It looks like the problematic patch is
> > 18de5bc4c1f1f1fa5e14f354a7603bd6e9d4e3b6. bisection was hard and I'm 95%
> > sure that this is the problematic patch. I'm currently using 2.6.23-rc6
> > with this reverted and so far resume works as it should.
> >
> >
> > commit 18de5bc4c1f1f1fa5e14f354a7603bd6e9d4e3b6
> > Author: Thomas Gleixner <tglx@linutronix.de>
> > Date:   Sat Jul 21 04:37:34 2007 -0700
> >
> >     clockevents: fix resume logic
>
> Linus pulled a series of patches which are addressing this issue into
> his tree yesterday. Can you please retest against current git ?

Looks like the problem is fixed in current git for me. Thanks!

ps. The description about vaio not resuming without key pressing matches what 
I was seeing here on thinkpad z60m, too.

> 	tglx



-- 
Arkadiusz Mi¶kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
