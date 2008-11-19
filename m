Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbYKSTB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbYKSTB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 14:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbYKSTBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 14:01:15 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47827 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbYKSTBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 14:01:13 -0500
Date: Wed, 19 Nov 2008 13:53:40 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       sfr@canb.auug.org.au
Subject: Re: pull request: wireless-2.6 2008-11-18
Message-ID: <20081119185340.GC3485@tuxdriver.com>
References: <20081119000719.GA19756@tuxdriver.com> <1ba2fa240811182246m17a6baf0ybde19af030a65819@mail.gmail.com> <1ba2fa240811190134u7974a840i532e8ed0e18f8c72@mail.gmail.com> <20081119143919.GA3485@tuxdriver.com> <1ba2fa240811190851i5dda6734w10d38b0f27e5ac97@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ba2fa240811190851i5dda6734w10d38b0f27e5ac97@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2008 at 06:51:49PM +0200, Tomas Winkler wrote:
> On Wed, Nov 19, 2008 at 4:39 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
> > On Wed, Nov 19, 2008 at 11:34:37AM +0200, Tomas Winkler wrote:
> >> On Wed, Nov 19, 2008 at 8:46 AM, Tomas Winkler <tomasw@gmail.com> wrote:
> >> > On Wed, Nov 19, 2008 at 2:07 AM, John W. Linville
> >> > <linville@tuxdriver.com> wrote:
> >
> >> >>      mac80211: remove ieee80211_notify_mac
> >> >>      iwlagn: fix RX skb alignment
> >> >
> >> > IMHO its premature pushing ttese 2 patches up, they came in yestrday
> >> > and nobody here has run tthe code
> >
> > Well, thanks for your opinion.  Here is mine:
> >
> > The iwlwifi drivers have been hitting these problems for months,
> > and I have seen no effort by your team to address the problems.
> 
> There is a lot of effort to solve this I'm not sure what mailing list
> are u reading.
> We even presented test patches with alignment issues as Johannes few
> month ago but
> we didn't get the feedback that it hit anything. So you are totally off here.

Citation needed.  All I see is Johannes' patch followed by your FUD.

> > It is possible that your team is working on them behind closed doors
> > and will eventually throw something over the wall to us.  I'm tired
> > of waiting for that, and I imagine that hordes of iwlagn users are
> > tired of waiting as well.
> 
> This is embarrassing also for us that we cannot locate this specific
> problem but it not like we are not doing anything.Not sure there are
> other examples that we are not addressing bugs promptly.
> 
> > Johannes has presented us with plausible fixes, and people are
> > reporting that the patches work for them.
> 
> I'm not against merging these patches to wireless-testing but pushing
> them upstream before testing them
> is just plainly wrong and all I asked for to test them. You are
> presenting here double standards here.

Others have tested it already.

>  I can merge these patches,
> > or wait/hope/pray for some to come from your team.  Experience suggests
> > that if fixes do come from your team that they will either be buried
> > in some monster patch that largely addresses something else, or
> > that the patches will arrive with a changelog that is terse and/or
> > unintelligble.  Subsequently, I am not optimistic about waiting.
> 
> I've believe that we are addressing all the complains above and
> currently  if you are not seeing this I'm really sorry.

I'm not seeing it.

> > I think Johannes cited four different bugzilla.kernel.org entries
> > between those two patches.  What is your team doing to address
> > those bugs?
> 
> Again you are not reading the mailing list and not the bugs logs.

http://bugzilla.kernel.org/show_bug.cgi?id=11731
http://bugzilla.kernel.org/show_bug.cgi?id=11818
http://bugzilla.kernel.org/show_bug.cgi?id=11923
http://bugzilla.kernel.org/show_bug.cgi?id=11983
http://bugzilla.kernel.org/show_bug.cgi?id=12017
http://bugzilla.kernel.org/show_bug.cgi?id=12044
http://bugzilla.kernel.org/show_bug.cgi?id=12046

Those are only the ones not assigned to a specific person.  Yet, each
of them has a member of your team CC'ed.  Also, I made no effort to
track-down the ones in vendor bugzillas.

> > Obviously, I still think that those patches should be merged.
> 
> I'm not against just give it day or two to run it.  We have for
> example nightly regression builds with publicly available results why
> you cannot wait till we can run?  I think you've hurried to push it up
> just as a statement forgetting of possible regressions.

I merely did not wait for your blessing, mostly because I have no
idea when it might come.

> >> Just checked our bug database,  the ieee80211_notify_mac was
> >> introduced mainly to overcome HW bug when
> >> receiver become deaf  in heavy traffic such as ftp in noisy
> >> environment. Otherwise reconnection was too slow to keep ftp going. We
> >> need to check whether we are still hitting this before applying
> >> removal this function
> >
> > You are welcome to submit patches that address your hardware issue
> > and which do not introduce locking problems.
> 
> That was my suggestion that we fix it and I believe  we have normal
> discussion about it till you took your eager pushing steps. Replacing
> one regression with another is just not sane.

ieee80211_notify_mac is creating locking problems.  I'd rather hit
a few disconnects than endure locking problems.

Now, if you could put as much energy into fixing these issues as you
are putting into arguing with me or anyone else contradicting you...

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
