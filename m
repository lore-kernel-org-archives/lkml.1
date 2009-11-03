Return-Path: <linux-kernel-owner+w=401wt.eu-S1755516AbZKCIWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbZKCIWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 03:22:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbZKCIWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 03:22:03 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:41363 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbZKCIWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 03:22:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Fu6WGOJ7nLmzaX6hYzsE/b2iPC5LQodS5ro0vPcDwBjfqduZAYxtG+prBcF4AkYLYx
         2DpaDNO7Hlc5D1RCr+BE2m/A0LgkQP6Ub9KupGS00LgmyTzvuhb5TDvCmmtXPgrcYVMn
         F0cQrrPe88gw4wu+2v8jklRckNV2dv3UrdbQI=
Date: Tue, 3 Nov 2009 00:22:02 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcel Holtmann <marcel@holtmann.org>, David Miller <davem@davemloft.net>,
       torvalds@linux-foundation.org, linville@tuxdriver.com,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Please consider reverting
	7d930bc33653d5592dc386a76a38f39c2e962344
Message-ID: <20091103082201.GG3212@core.coreip.homeip.net>
References: <20091103053156.GA3212@core.coreip.homeip.net> <20091102.224957.32364226.davem@davemloft.net> <20091103065238.GE3212@core.coreip.homeip.net> <1257232587.3420.55.camel@localhost.localdomain> <1257234299.28469.25.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257234299.28469.25.camel@johannes.local>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, 2009 at 08:44:59AM +0100, Johannes Berg wrote:
> On Tue, 2009-11-03 at 16:16 +0900, Marcel Holtmann wrote:
> 
> > and can we please stop jumping the gun here and going past the subsystem
> > maintainers. I think this happens a little bit too much lately.
> 
> I'll rant a bit too -- I've been very annoyed by this many times. Note
> this isn't really against you (Dmitry) in particular, just another
> case ... but it does tick me off that many times when somebody manages
> to blame a failure on a specific commit the first thing they do is ask
> somebody way "above" (in terms of patch flow into mainline) the person
> writing the patch (like Linus here) to revert it.
> 

I do not understand what the fuss is about. We are pretty far in release
process (rc6 is about to be cut I'd expect) and we have an issue that
for all practical purposes kills the box on resume. Yes, I want action
to be swift in this case and (unless author or maintainer - who were
CCed on the email - have otehr solutiuon) the offending commit to be
reverted. If it was rc1 or rc2 or 3 I'd feel differently.

> It'd help communication and be so much more friendly if the subject was
> "found problem with commit ..." instead of "please consider
> reverting ..." (which was comparatively friendly already!). You can even
> leave the body almost identical, but I think it's presumptuous to
> effectively say "hey I know the solution for the problem already".

Not at all. I do know the solution since reverting this commit makes by
laptop operable again. It may not be the best solution in the long run
but a solution nonetheless.

> I'll
> venture a guess and say that wasn't even the intent, but it certainly
> comes across like that if you write an email with this subject, and
> start the body with "Hi Linus," not even addressing the patch author,
> just adding them to CC out of courtesy.
> 
> Should I think this is accepted practice?
> 

Again, I do not see the problem here. We have a severe regression so
yes, I am addressing Linus and asking him to consider reverting bad
commit. I also CCing the author and the wireless maintainer so they
can object if they have alternative solution. If the problem was in a
single driver I might consider doing it differenty but I think this
commit affects many wireless drivers.

-- 
Dmitry
