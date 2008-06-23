Return-Path: <linux-kernel-owner+w=401wt.eu-S1760350AbYFWRRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760350AbYFWRRQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 13:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbYFWRRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 13:17:04 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:2389 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347AbYFWRRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 13:17:03 -0400
Date: Mon, 23 Jun 2008 12:55:39 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: Oops report for the week preceding June 16th, 2008
Message-ID: <20080623165539.GB13860@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48591A30.1020206@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> Johannes Berg wrote:
> > That's more a case of Fedora living on the bleeding edge. The code is
> > fairly stable, all in linux-next, but the churn tends to be high because
> > of internal API changes that affect all drivers. Currently, I don't
> > think there is actually any _feature_ pending in linux-next, only
> > internal cleanups. Such cleanups are desirable, but at the same time can
> > lead to instability, hence being kept out of .26-git for the time being,
> > and are in -next for .27. Mostly because we only wrote them after .26
> > started.
> > 
> 
> My concern is that if there's something technological in the "bleeding tree" that is
> so valuable to users that distros feel that it's ready "enough" and that they need to
> pick it up for their users, we have a flaw in our processes in moving to slow for
> users. From what you described that's not the case for wireless (more a case of
> Fedora jumping off the bridge while forgetting to tie down the bungee cord ;-), and
> that's good. I hope the same applies for the ALSA parts....

My first question is "how do you guys know to start these discussions
when I go on vacation?" :-)  I was out of town last week and missed
this little eruption, so forgive my late reply.  Given my pertinent
role in the topic, I thought I should still remark.

I would remind anyone that at one time there was still a lot of pressue
to _not_ merge the new wireless bits upstream.  The reasons for that
pressure were mentioned elsewhere in this thread -- mostly fear of
introducing new/instable userland ABI as well as general concerns
about the design/implementation of what is now the mac80211 component.
My own lack of experience as a maintainer contributed here, as I
was often uncertain about how to get things moving along sooner.
Thankfully my experience dealing with these maintenance issues
has increased.  Moreover the external pressure against merging has
subsided due both to some technical resolutions and also perhaps to
a shift in attitude about what is mergeable upstream.  I don't think
there is any remaining logjam with regard to upstream wireless merges.

The practice of pushing cutting-edge wireless stuff into Fedora
started as a means of getting testers.  Once it was in Rawhide, it
never made sense to yank it away from users.  So, I have continued
the process of merging what is now known as -next wireless bits into
Fedora.  This is at least partly because I haven't figured-out how to
gracefully stop doing that. :-)  In fact, in Fedora 9 I have started
to stage those bits more slowly between -next, Rawhide, F9, and F8.
FWIW, I think this staging (rather than pushing new -next stuff into
F{10,9,8} more-or-less immediately) may have created the window for
releasing the bad Fedora kernels that plagued kerneloops.org last week.

Anyway, the wireless bits in Fedora are all on their way upstream.
The ones that aren't in linux-2.6 are only missing due to the
"bugfixes only after -rc" policy, not some systemic refusal to merge.
Given the current process, it would be impossible to get them upstream
any faster.  In fact, getting exposure in Fedora gives us an early jump
in _avoiding_ upstream regressions when these bits get into 2.6.27-rc1.
The fact that it _usually_ make things better for Fedora wireless
users is just gravy. :-)

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
