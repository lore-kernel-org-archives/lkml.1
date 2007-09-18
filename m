Return-Path: <linux-kernel-owner+w=401wt.eu-S1755590AbXIRH1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbXIRH1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 03:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbXIRH1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 03:27:48 -0400
Received: from nn7.de ([85.214.94.156]:44655 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754724AbXIRH1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 03:27:47 -0400
Subject: Re: [3/3] 2.6.23-rc6: known regressions v2
From: Soeren Sonnenburg <kernel@nn7.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Arkadiusz Miskiewicz <arekm@maven.pl>, "Rafael J\. Wysocki" <rjw@sisk.pl>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>,
       Thomas Voegtle <tv@lio96.de>
In-Reply-To: <1190063028.2995.53.camel@chaos>
References: <46EB3EF8.6040103@googlemail.com>
	 <200709172144.43761.arekm@maven.pl> <1190058463.2995.14.camel@chaos>
	 <200709172251.07769.arekm@maven.pl>  <1190063028.2995.53.camel@chaos>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 18 Sep 2007 09:07:29 +0200
Message-Id: <1190099250.29236.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-17 at 23:03 +0200, Thomas Gleixner wrote:
> On Mon, 2007-09-17 at 22:51 +0200, Arkadiusz Miskiewicz wrote:
> > > >     clockevents: fix resume logic
> > >
> > > Linus pulled a series of patches which are addressing this issue into
> > > his tree yesterday. Can you please retest against current git ?
> > 
> > Looks like the problem is fixed in current git for me. Thanks!
> 
> Thanks for testing.

I can confirm that the problem is fixed for me too in current git when
using the free avivo driver (with the binary only fglrx driver the
machine just hangs on resume or even sometimes on sleep). So it might be
worth to purposely keep that such that people transit from fglrx to the
free avivo/radeonhd drivers. Anyway s2ram with avivo takes 2-3 sec to
suspend and 4-5 for resume (when fglrx worked it was more in the 10-20
secs).

Soeren.
-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
