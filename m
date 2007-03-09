Return-Path: <linux-kernel-owner+w=401wt.eu-S2993023AbXCIHEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993023AbXCIHEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 02:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993024AbXCIHEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 02:04:55 -0500
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:46621
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993023AbXCIHEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 02:04:54 -0500
Date: Thu, 8 Mar 2007 23:04:46 -0800
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bill Davidsen <davidsen@tmr.com>, Ed Tomlinson <edt@aei.ca>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Revell <rlrevell@joe-job.com>,
       Nicolas Mailhot <nicolas.mailhot@laposte.net>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler
Message-ID: <20070309070446.GA3487@gnuppy.monkey.org>
References: <54348.192.54.193.51.1173087934.squirrel@rousalka.dyndns.org> <75b66ecd0703051020h1f0c1f85r15a5de082a80cec0@mail.gmail.com> <200703051419.25814.gene.heskett@gmail.com> <200703052123.29421.edt@aei.ca> <Pine.LNX.4.64.0703051849410.3998@woody.linux-foundation.org> <45F0DCB7.5020908@tmr.com> <Pine.LNX.4.64.0703082226530.10832@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703082226530.10832@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2007 at 10:31:48PM -0800, Linus Torvalds wrote:
> On Thu, 8 Mar 2007, Bill Davidsen wrote:
> > Please, could you now rethink plugable scheduler as well? Even if one had to
> > be chosen at boot time and couldn't be change thereafter, it would still allow
> > a few new thoughts to be included.
> 
> No. Really.
> 
> I absolutely *detest* pluggable schedulers. They have a huge downside: 
> they allow people to think that it's ok to make special-case schedulers. 
> And I simply very fundamentally disagree.

Linus,

This is where I have to respectfully disagree. There are types of loads
that aren't covered in SCHED_OTHER. They are typically certain real time
loads and those folks (regardless of -rt patch) would benefit greatly
from having something like that in place. Those scheduler developers can
plug in (at compile time) their work without having to track and forward
port their code constantly so that non-SCHED_OTHER policies can be
experimented with easily.

This is especially so with rate monotonic influenced schedulers that are
in the works by real time folks, stock kernel or not. This is about
making Linux generally accessible to those folks and not folks doing
SCHED_OTHER work. They are orthogonal.

bill

