Return-Path: <linux-kernel-owner+w=401wt.eu-S1758954AbYFJXLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758954AbYFJXLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 19:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755197AbYFJXLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 19:11:12 -0400
Received: from 1wt.eu ([62.212.114.60]:1695 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525AbYFJXLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 19:11:11 -0400
Date: Wed, 11 Jun 2008 01:10:56 +0200
From: Willy Tarreau <w@1wt.eu>
To: Chris Wright <chrisw@sous-sol.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.25.6
Message-ID: <20080610231055.GN5609@1wt.eu>
References: <20080609194924.GL30402@sequoia.sous-sol.org> <20080610145325.GC23351@khazad-dum.debian.net> <20080610191726.GB4218@tatooine.rebelbase.local> <20080610201218.GM4018@sequoia.sous-sol.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080610201218.GM4018@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 01:12:23PM -0700, Chris Wright wrote:
> * markus reichelt (ml@mareichelt.de) wrote:
> > * Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> > > On Mon, 09 Jun 2008, Chris Wright wrote:
> > > > We (the -stable team) are announcing the release of the 2.6.25.6
> > > > kernel.
> > > > 
> > > > It contains a number of assorted bugfixes all over the tree.  Users are
> > > > encouraged to update.
> > > 
> > > It also contains at least one security bugfix, as some were quick
> > > to point out in not-so-kind words:
> > > 
> > > http://lwn.net/Articles/285438/
> > 
> > I agree that security bugfixes should be pointed out more clearly.
> 
> I don't think anybody is disagreeing with that.  It's not always
> obvious to bug submitters or fixers what the security implications are.
> While Brad has a good point, esp. w.r.t. the specific cpufreq bug he
> picked out having security implications, it is not true that we are
> actively hiding security bugs.  Had I realized there was a security
> issue, I would highlight it in the announce message.  In fact, that's
> our standard procedure for -stable.

I second this Chris. When I merge a fix into 2.4, I generally wait
for -stable to release it so that I can reuse the same message and
subject which already includes the reference to the vulnerability
if any.

I don't like obfuscation at all WRT security issues, it does far more
harm than good because it reduces the probability to get them picked
and fixed by users, maintainers, distro packagers, etc...

It's a shame that Brad does not post here, he could have yelled
during the review phase in order to get more explicit changelogs.
*that* would have served a useful purpose. Whining afterwards is
useless though :-/

Willy

