Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbYCMLcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbYCMLcB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 07:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751744AbYCMLbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 07:31:53 -0400
Received: from styx.suse.cz ([82.119.242.94]:50738 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751674AbYCMLbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 07:31:52 -0400
Date: Thu, 13 Mar 2008 12:31:50 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Mike Galbraith <efault@gmx.de>
cc: Jan Knutar <jk-lkml@sci.fi>, linux-kernel@vger.kernel.org,
       Hans-Peter Jansen <hpj@urpla.net>,
       David Newall <davidn@davidnewall.com>, Theodore Tso <tytso@mit.edu>,
       "Fred ." <eldmannen@gmail.com>
Subject: Re: Keys get stuck
In-Reply-To: <1205407693.6686.16.camel@marge.simson.net>
Message-ID: <Pine.LNX.4.64.0803131230230.30831@jikos.suse.cz>
References: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com> 
 <200803122222.05663.hpj@urpla.net>  <1205386933.4797.22.camel@marge.simson.net>
  <200803131148.22056.jk-lkml@sci.fi> <1205407693.6686.16.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008, Mike Galbraith wrote:

> > I'm not sure if it's the same issue or not, they don't repeat 
> > "forever" for me, it just makes my speeellllliingggg llllooookkk 
> > teerrriibbblle. Like that. Before this happens, letters usually stop 
> > appearing on screen as I'm typing. I usually stop typing at that 
> > point, since I know it will just become a mess.
> Yes, that's the symptom I was refering to.  If you see that under
> reasonable CPU load, and _without_ major swapping going on, then I'd be
> suspicious of scheduler trouble.  Swap can definitely keep X off the cpu
> for extended periods, and that seems to be what triggers the repeated
> keys behavior.  (I've never troubleshot it, so must say _seems_)

I have a hard time calling this a kernel scheduler trouble. My 
understanding is that X are sometimes unhappy how kernel schedules them 
when under load, and that triggers bug in X autorepeat code.

-- 
Jiri Kosina
SUSE Labs
