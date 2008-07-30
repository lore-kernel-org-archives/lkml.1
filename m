Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbYG3Es2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbYG3Es2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 00:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbYG3EsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 00:48:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41675
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751084AbYG3EsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 00:48:19 -0400
Date: Tue, 29 Jul 2008 21:48:15 -0700 (PDT)
Message-Id: <20080729.214815.17075710.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, tytso@MIT.EDU, alistair@devzero.co.uk,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dsd@gentoo.org, kune@deine-taler.de, linux-wireless@vger.kernel.org
Subject: Re: 2.6.27-rc1: zd1211rw association fails
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080729175206.GB4923@tuxdriver.com>
References: <1217333359.10489.38.camel@johannes.berg>
	<1217333706.10489.40.camel@johannes.berg>
	<20080729175206.GB4923@tuxdriver.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 29 Jul 2008 13:52:06 -0400

> On Tue, Jul 29, 2008 at 02:15:06PM +0200, Johannes Berg wrote:
> > 
> > > > Yeah, it's really too bad -rc1 got released just before you were able
> > > > to post the fix to this, since if there were 100 million people who
> > > > were trying out kernels starting with -git7 that use wireless, there
> > > > will probably be 200 million people trying out -rc1.  :-)
> > > > 
> > > > Thanks for finding and fixing it, though.  I stopped trying out
> > > > kernels after -git6 since I was travelling at OSCON, and not having
> > > > wireless was a show-stopper for me....
> > > 
> > > If everybody's going to decide now to hit on _me_, I'll point out that
> > > davem's MQ TX changes broke it
> > 
> > Of course that's not strictly true, it had been broken forever, it just
> > happened to never show up before. And I mean forever, the original
> > devicescape code that got in was already broken.
> 
> FWIW, I think the MQ stuff didn't spend much (or any) time in -next...

It did in a few formats, but then Patrick McHardy pointed out something
that required my rewriting large swaths of it in the days leading up to
the merge window.

And the problem this showed up was a bug that existed in mac80211 long
before I made any TX multiqueue changes :-)
