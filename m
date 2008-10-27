Return-Path: <linux-kernel-owner+w=401wt.eu-S1753787AbYJ0TO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbYJ0TO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 15:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbYJ0TOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 15:14:16 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:45642 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901AbYJ0TOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 15:14:15 -0400
Date: Mon, 27 Oct 2008 20:13:07 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>, Soeren Sonnenburg <kernel@nn7.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       tomas.winkler@intel.com, "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org
Subject: Re: Suspend to RAM regression in 2.6.28-rc2 (bisected)
Message-ID: <20081027191307.GI22217@kernel.dk>
References: <20081027162054.GA4015@localhost.aei.mpg.de> <200810271832.40717.rjw@sisk.pl> <1225130844.4466.0.camel@localhost> <1225132278.3796.32.camel@johannes.berg> <1225133082.3796.35.camel@johannes.berg> <20081027190011.GA3951@localhost.aei.mpg.de> <20081027190631.GG22217@kernel.dk> <1225134571.3796.41.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225134571.3796.41.camel@johannes.berg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27 2008, Johannes Berg wrote:
> On Mon, 2008-10-27 at 20:06 +0100, Jens Axboe wrote:
> > On Mon, Oct 27 2008, Carlos R. Mafra wrote:
> > > On Mon 27.Oct'08 at 19:44:42 +0100, Johannes Berg wrote:
> > > > On Mon, 2008-10-27 at 19:31 +0100, Johannes Berg wrote:
> > > > > On Mon, 2008-10-27 at 19:07 +0100, Soeren Sonnenburg wrote:
> > > > > 
> > > > > > > Johannes, can you pls have a look?
> > > > > 
> > > > > I did, and I have no idea. Makes no sense at all.
> > > > 
> > > > The only thing I can remotely think of is that iwlwifi doesn't like
> > > > being called back from within the call that it did to mac80211, which
> > > > obviously happens here. But I have no idea, the code as it stands is
> > > > correct, just the interaction with iwlwifi's resume seems to be broken.
> > > > 
> > > > Try this patch instead:
> > > 
> > > Yep, with this patch it also works!
> > 
> > Confirmed here as well, my x60 is happy again.
> 
> Thanks. Another alternative I could think of is deferring the
> notifications to a work struct, but I'd rather see that in the driver I
> think, not sure though, could be argued either way.

If you want something else tested, just let me know. I don't care a
whole lot about how it gets fixed, as long as it does :-). I use STR
heavily, so it's quite a burden to have it broken.


-- 
Jens Axboe

