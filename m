Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbYKQT5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbYKQT5F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 14:57:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbYKQT4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 14:56:54 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:51020 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751808AbYKQT4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 14:56:53 -0500
Date: Mon, 17 Nov 2008 14:53:52 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Frans Pop <elendil@planet.nl>
Cc: eo@nebensachen.de, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       mingo@elte.hu, bugme-daemon@bugzilla.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [Bug 11905] REGRESSION: lots of extra timer interrupts costing
	power
Message-ID: <20081117195352.GE14523@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Frans Pop <elendil@planet.nl>, eo@nebensachen.de,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
	bugme-daemon@bugzilla.kernel.org, akpm@linux-foundation.org
References: <E1KvN6w-0002QE-E3@closure.thunk.org> <20081031031516.GA9781@mit.edu> <87mygl2hg1.fsf@denkblock.local> <87mygl2hg1.fsf@denkblock.local> <20081117081326.GA14523@mit.edu> <200811171036.49067.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811171036.49067.elendil@planet.nl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2008 at 10:36:48AM +0100, Frans Pop wrote:
> Theodore Tso wrote:
> > Hi, what's going on with this regression?  To refresh people's memory,
> > I tracked down the excess interrupts to a specific commit, fb02fbc1,
> > and I've been running quite happily with a patch to revert this
> > commit.
> 
> Isn't that solved by this commit (included in -rc5)?
> 
> commit ae99286b4f1be7788f2d6947c66a91dbd6351eec
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Mon Nov 10 13:20:23 2008 +0100
> 
>     nohz: disable tick_nohz_kick_tick() for now

Yep, so it is.  Sorry, I missed that; I haven't migrated to -rc5 yet.

I'll close the Bugzilla entry.

							- Ted
