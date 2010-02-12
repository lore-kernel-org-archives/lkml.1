Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088Ab0BLV72 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 16:59:28 -0500
Received: from poutre.nerim.net ([62.4.16.124]:61280 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755677Ab0BLV70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 16:59:26 -0500
Date: Fri, 12 Feb 2010 22:59:23 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: "J.H." <warthog9@kernel.org>, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       users@kernel.org, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>, mirrors@kernel.org
Subject: Re: [kernel.org users] XZ Migration discussion
Message-ID: <20100212225923.36a67112@hyperion.delvare>
In-Reply-To: <4B75B2A6.5080006@lougher.demon.co.uk>
References: <4B744E13.8040004@kernel.org>
	<20100212150137.648dca7c@hyperion.delvare>
	<4B75A5CF.70308@lougher.demon.co.uk>
	<20100212203209.0cb8afc3@hyperion.delvare>
	<4B75B2A6.5080006@lougher.demon.co.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Feb 2010 19:57:26 +0000, Phillip Lougher wrote:
> Jean Delvare wrote:
> > On Fri, 12 Feb 2010 19:02:39 +0000, Phillip Lougher wrote:
> >> 5* Archive all the older 2.6.x files and move them into a separate
> >>     directory (e.g. v2.6-pre20).  Moving all the pre 2.6.20 files
> >>     saves 42% of the file listing.
> >>
> >> This seems an obvious solution, what am I missing?
> > 
> > This is confusing, inconsistent and unstable. Confusing because 2.6-pre
> > referred so far to the releases immediately preceding 2.6.0.
> 
> I didn't say "2.6-pre", anyway it could be called something different,
> like 'older-releases'.
> 
> > Inconsistent because it requires the downloader to have preliminary
> > knowledge about what the break point is. Unstable because, while you
> > consider pre20 to qualify as "old" today, in 5 years you will want
> > pre30 to qualify as "old" instead, meaning that tools such as ketchup
> > would have to be updated once again.
> 
> You yourself said "I wouldn't worry too much about breaking the current locations.
> Just give some time for software authors (ketchup comes to mind) to update
> their code and it shouldn't be a big problem."

Yes, I did say that, and I can repeat it if needed. There's a big
difference between breaking an old scheme which used to be valid and
happens to no longer be, and designing a new scheme where breakages are
bound to happen by design. Even if technically that's the same
breakage, its reception by the affected users will be very different,
because in the latter case you have no excuse.

> The major advantage with my suggestion is for the majority of users/tools
> interested in "recent" kernels, nothing changes at all.

Prove it. Many people out there are still working on older trees. I am
working on 2.6.5 and 2.6.16 kernels on a weekly basis. If ketchup or
other tools break for these trees only and not more recent ones, that
won't help me at all, I will still have to update them.

> Your suggestions break everything for everyone.

This doesn't make me happy, but at least it is consistent and durable.
When you change something for everyone, it has the advantage that the
solutions are general, come quickly and are widely documented. Using
quirks to limit the effects is a burden for the future, and may not
even help that much in practice.

> > I think we want to come up with a directory structure which won't change
> > in the future.
> 
> I think trying to do that is utterly futile.

You didn't have to join this discussion in the first place.

-- 
Jean Delvare
