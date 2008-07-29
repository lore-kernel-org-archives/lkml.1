Return-Path: <linux-kernel-owner+w=401wt.eu-S1756949AbYG2PTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949AbYG2PTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 11:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbYG2PTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 11:19:36 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:35114 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751862AbYG2PTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 11:19:35 -0400
Date: Tue, 29 Jul 2008 11:18:30 -0400
From: Theodore Tso <tytso@MIT.EDU>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Alistair John Strachan <alistair@devzero.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dsd@gentoo.org, kune@deine-taler.de, linux-wireless@vger.kernel.org
Subject: Re: 2.6.27-rc1: zd1211rw association fails
Message-ID: <20080729151830.GA5126@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Johannes Berg <johannes@sipsolutions.net>,
	Alistair John Strachan <alistair@devzero.co.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dsd@gentoo.org, kune@deine-taler.de, linux-wireless@vger.kernel.org
References: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org> <200807291049.47342.alistair@devzero.co.uk> <1217326195.10489.10.camel@johannes.berg> <20080729120442.GE9378@mit.edu> <1217333359.10489.38.camel@johannes.berg> <1217333706.10489.40.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217333706.10489.40.camel@johannes.berg>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 02:15:06PM +0200, Johannes Berg wrote:
> > If everybody's going to decide now to hit on _me_, I'll point out that
> > davem's MQ TX changes broke it
> 
> Of course that's not strictly true, it had been broken forever, it just
> happened to never show up before. And I mean forever, the original
> devicescape code that got in was already broken.

Sorry, no, I wasn't trying to blame you.  I understand that this was a
hard problem to fix, and it wasn't at all obvious that changes in one
part of the networking stack would break wireless stack due to bad
assumptions it had made, that had been hiding for quite some time.

The timing is just very unfortunate, since if -rc1 had been delayed by
just one more day so it could have incorporated it we would probably
reduce the large number of regression reports; a lot of people who
test -rc1 don't necessarily follow netdev or linux-wireless.

I'm of course also nervously building -rc1 and about to test it, since
I haven't had a chance to test anything since -git6, and I'm wondering
if some other regression may have been introduced since then.

Since it probably doesn't get said enough to everyone who works of
fixing bugs/regressions, thanks very much for your efforts; I (and
many other people) very much appreciate it!!

						- Ted
