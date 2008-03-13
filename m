Return-Path: <linux-kernel-owner+w=401wt.eu-S1755543AbYCMMFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbYCMMFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 08:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbYCMMFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 08:05:19 -0400
Received: from brick.kernel.dk ([87.55.233.238]:15156 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008AbYCMMFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 08:05:17 -0400
Date: Thu, 13 Mar 2008 13:05:14 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>,
       Arkadiusz Miskiewicz <arekm@maven.pl>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-rc2 Regression Thinkpad acpi
Message-ID: <20080313120514.GH17940@kernel.dk>
References: <20080225230035.GA14503@khazad-dum.debian.net> <20080312133529.GB21290@khazad-dum.debian.net> <20080312135521.GE8141@ics.muni.cz> <200803121952.42666.arekm@maven.pl> <20080312193637.GA27873@ics.muni.cz> <20080312211306.GD30864@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080312211306.GD30864@khazad-dum.debian.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12 2008, Henrique de Moraes Holschuh wrote:
> On Wed, 12 Mar 2008, Lukas Hejtmanek wrote:
> > On Wed, Mar 12, 2008 at 07:52:41PM +0100, Arkadiusz Miskiewicz wrote:
> > > I'm also seeing regression on my thinkpad z60m where with git tree (tested 
> > > again with 2 days old git) "thinkvantage" button stopped working (pressing it 
> > > was previously seen by some userspace kde which run konsole).
> > > 
> > > On 2.6.24 presses are seen.
> > 
> > well, on 2.6.25-rc4, some keys are not reported as input (xev does not see any
> > key press), some keys are. Is this desired? Or all the keys (fn+f1-12 + volume
> > + backlight + think vantage) should be reported as some input event and thus
> > acpid makes no sense any more?
> 
> xev has to get events from somewhere.  That somewhere happens to be a buggy
> mess right now (X.org evdev device).  Or it is getting it through some other
> middleware, like HAL, which can have its own problems.
> 
> If you want to test thinkpad-acpi functionality, get HAL and X.org out of
> the way.  The easiest way is to do it in single user mode.

And lets now get back to reality - the reality that now breaks the
previously working setup of lots of users. So you are telling me that in
order to get my volume key functionality back I have to get rid of HAL
and X?

Lets turn back time a bit. Why was this change made? IOW, what was the
reason for breaking a working setup for lots of users? It better be a
damn good reason, or I would heavily argue for reverting this change so
that 2.6.25 actually WORKS as expected for thinkpad users.

-- 
Jens Axboe

