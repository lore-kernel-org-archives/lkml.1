Return-Path: <linux-kernel-owner+w=401wt.eu-S1754795AbYBCWs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbYBCWs0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 17:48:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbYBCWsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 17:48:18 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56760 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751035AbYBCWsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 17:48:17 -0500
Date: Sun, 3 Feb 2008 23:48:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Brownell <david-b@pacbell.net>
Cc: rjw@sisk.pl, mingo@elte.hu, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] sleepy linux self-test
Message-ID: <20080203224831.GE2799@elf.ucw.cz>
References: <20080130131748.GA3796@elf.ucw.cz> <200802031321.27828.rjw@sisk.pl> <20080203131636.4100828D3E1@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <200802032229.30576.rjw@sisk.pl> <20080203224206.8FD40166811@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080203224206.8FD40166811@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > The changes look good to me.
> 
> They feel unfinished to me though.  :)
> 
> Like using "jiffies" instead of a clocksource, which makes trouble
> since the timing covers periods with IRQs disabled.  And the test
> mode parameter needs work.

Well, I'd say that timing has bigger problem, right?

It is

set alarm
	suspend system
| poweroff
alarm expires
	system resumes

... so you are measuring resume time + sleep time, no? 

> > Well, it would be nice to have this feature in as soon as reasonably possible,
> > so that people can include suspend tests in the automated testing.
> 
> Except ... "rtcwake" (from util-linux-ng) already supports such
> testing, albeit from userspace.   But not the timing tests.
> 
> What was the rationale for wanting this done in-kernel?  (Other
> than to know it can work portably.)

Ingo has to answer this one...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
