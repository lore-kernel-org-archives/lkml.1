Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbYBPHjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbYBPHjg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 02:39:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbYBPHj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 02:39:26 -0500
Received: from 1wt.eu ([62.212.114.60]:1977 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbYBPHjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 02:39:25 -0500
Date: Sat, 16 Feb 2008 08:39:08 +0100
From: Willy Tarreau <w@1wt.eu>
To: Valdis.Kletnieks@vt.edu
Cc: Bill Davidsen <davidsen@tmr.com>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Driver removals
Message-ID: <20080216073907.GT8953@1wt.eu>
References: <fp08q7$jv0$1@ger.gmane.org> <20080214082547.GJ12383@cs181133002.pp.htv.fi> <47B5E2FD.9060908@tmr.com> <20080215222830.GA9962@cs181133002.pp.htv.fi> <47B6377D.4050502@tmr.com> <26601.1203126747@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26601.1203126747@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 08:52:27PM -0500, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 15 Feb 2008 20:08:13 EST, Bill Davidsen said:
> 
> > can never make you see why technological extortion is evil. People have 
> > always moved to new drivers without pushing because they were *better*, 
> > guess that model is dead.
> 
> And the drivers get better because the Code Fairy comes and sprinkles magic
> bugfix dust all over them? And the Code Fairy knows where to sprinkle bugfix
> dust because it can see where the Bugreport Fairy sprinkled Bugreport Dust?
> 
> Yes, people will move without pushing when the drivers are better.  However,
> remember that a major cultural motivation for the GPL is the concept of "give
> back".  And if a user can't be bothered to even give back enough to say
> "wow, this blows, my Frobnozz9800 doesn't work with this driver", that's a
> problem with the user.

I don't understand why kernel developers always think that users spend
their whole time testing their new stuff. That is mostly true for a lot
of desktop users, but definitely not for servers. On a server, you may
*ignore* that a new driver exists for years. The basic make oldconfig
does the stuff right.

An old driver must spend some time marked "deprecated", if possible with
the config option changed so that at least *something* informs the admin
that it may soon be removed. It looks like this is something that people
building a kernel every day and never getting more than one week of uptime
do not understand. But there are many people who build once a year and
upgrade that often at most, unless there is a big security issue.

If the old driver simply keeps silently building when marked deprecated,
noone will notice. And as Bill pointed it out, we should also make sure
that when marked deprecated, the old one always refers to the new one so
that the guy noticing this during the build has time to set up a test
machine to try that new driver.

Not everyone has a mouse and a joystick attached to the computers he
builds kernels for...

Willy

