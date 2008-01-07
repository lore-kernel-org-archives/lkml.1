Return-Path: <linux-kernel-owner+w=401wt.eu-S1757938AbYAGSVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938AbYAGSVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 13:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbYAGSVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 13:21:10 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:55584 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbYAGSVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 13:21:09 -0500
Message-ID: <47826D5A.2050801@s5r6.in-berlin.de>
Date: Mon, 07 Jan 2008 19:20:10 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Michal Simek <simekm2@fel.cvut.cz>, linux-kernel@vger.kernel.org,
       monstr@monstr.eu
Subject: Re: New linux arch
References: <47820D24.3060800@fel.cvut.cz> <84144f020801070447t68808bcdq64bfc949c7732462@mail.gmail.com>
In-Reply-To: <84144f020801070447t68808bcdq64bfc949c7732462@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> On Jan 7, 2008 1:29 PM, Michal Simek <simekm2@fel.cvut.cz> wrote:
>> How many maintainers are acceptable? (one or more)
> 
> You can have as many maintainers as you want but you probably don't
> want to make it too many.

Bug reporters and patch submitters shouldn't be required to CC too many
addresses.

>> I see the right way to push all changes to public git repository and
>> then send patches in small logical group to LKML with CC to people from
>> microblaze community.
>>
>> And then wait for comments from you, solve problems, update git
>> repository and send changes again.
> 
> You don't necessarily need a public git repository before sending your
> patches to LKML but yeah, you definitely want some public exposure
> before asking for Linus/Andrew to merge your port.

Yes, patch review is always done on the mailing list(s).  Not only
during the initial submission, but also for all later changes.

A git repository provided by you could be used

  - by interested people to fetch your pre-integrated development
    sources,

  - by Andrew Morton to pull into -mm.  This needs to be a branch in
    your repo which only contains stuff which works to the best of your
    knowledge, i.e. is already tested and got at least some basic review
    by those involved in the subproject.  It always has to give a clean
    and working diff against Linus' current tree, because that's what
    Andrew bases -mm on.  (This means you have to rebase or otherwise
    update this branch whenever there were conflicting changes in Linus'
    tree.)  Also, if you need to do changes outside your subsystem,
    coordinate it with the tree owners of the other subsystems to
    minimize conflicts when Andrew assembles -mm.
    Alternatively to git, you could also work with Andrew via a quilt
    tree or via e-mail, depending on what turns out as most effective.

  - by Linus to pull into his tree if he thinks he can work with your
    tree better than via e-mail.  Regardless if git or e-mail, you are
    of course supposed to only offer stuff to Linus which is known to
    work and has been fully reviewed.
    New work (feature additions or removals, refactoring, intrusive bug
    fixes) needs to be sent to Linus early before an -rc1 release.
    Between -rc1 and -final, only bug fixes are acceptable.  (In early
    -rc's maybe also a few other small nonintrusive changes that can't
    possibly break anything...)

Note, everything which I said here only reflects what I remember as
required or most desirable; it's not a canonical list of requirements.

Anyway, it may be a little bit too early to think about those things
before you posted your initial submission for review and re-review...
-- 
Stefan Richter
-=====-==--- ---= --===
http://arcgraph.de/sr/
