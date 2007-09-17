Return-Path: <linux-kernel-owner+w=401wt.eu-S1757941AbXIQTsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbXIQTsH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 15:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755948AbXIQTrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 15:47:55 -0400
Received: from www.osadl.org ([213.239.205.134]:38198 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754021AbXIQTry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 15:47:54 -0400
Subject: Re: [3/3] 2.6.23-rc6: known regressions v2
From: Thomas Gleixner <tglx@linutronix.de>
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>,
       Thomas Voegtle <tv@lio96.de>, Soeren Sonnenburg <kernel@nn7.de>
In-Reply-To: <200709172144.43761.arekm@maven.pl>
References: <46EB3EF8.6040103@googlemail.com>
	 <46EB4374.50104@googlemail.com> <200709152020.33179.rjw@sisk.pl>
	 <200709172144.43761.arekm@maven.pl>
Content-Type: text/plain
Date: Mon, 17 Sep 2007 21:47:43 +0200
Message-Id: <1190058463.2995.14.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 (2.11.92-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-17 at 21:44 +0200, Arkadiusz Miskiewicz wrote:
> On Saturday 15 of September 2007, Rafael J. Wysocki wrote:
> > On Saturday, 15 September 2007 04:29, Michal Piotrowski wrote:
> 
> > > Subject         : resume from ram much slower
> > > References      : http://lkml.org/lkml/2007/8/10/275
> > > Last known good : 2.6.23-rc1 ?
> > > Submitter       : Arkadiusz Miskiewicz <arekm@maven.pl>
> > > Caused-By       : ?
> > > Handled-By      : Rafael J. Wysocki <rjw@sisk.pl>
> > > Status          : problem is being debugged
> >
> > Unresolved, bisection might be helpful.
> 
> Took 16 hours of bisecting and playing with stuff.
> 
> It looks like the problematic patch is 18de5bc4c1f1f1fa5e14f354a7603bd6e9d4e3b6.
> bisection was hard and I'm 95% sure that this is the problematic patch.
> I'm currently using 2.6.23-rc6 with this reverted and so far resume works as it should.
> 
> 
> commit 18de5bc4c1f1f1fa5e14f354a7603bd6e9d4e3b6
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Sat Jul 21 04:37:34 2007 -0700
> 
>     clockevents: fix resume logic

Linus pulled a series of patches which are addressing this issue into
his tree yesterday. Can you please retest against current git ?

	tglx


