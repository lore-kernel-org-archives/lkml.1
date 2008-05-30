Return-Path: <linux-kernel-owner+w=401wt.eu-S1752906AbYE3Xhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbYE3Xhi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 19:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbYE3Xha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 19:37:30 -0400
Received: from smtp-out.google.com ([216.239.33.17]:49461 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbYE3Xh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 19:37:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=uoGGuWPzvKT3hK/itrQlnNM3ovlGXQQWLlhwlAf4R1MDSXLTaVWTNVUimOb74wfB+
	0e4XuvqWcJfsLiciSwSNQ==
Message-ID: <da824cf30805301637l2aa80d46l3d941eba92212995@mail.gmail.com>
Date: Fri, 30 May 2008 16:37:20 -0700
From: "Grant Grundler" <grundler@google.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [Ksummit-2008-discuss] How many contributors are we losing
Cc: "Luck, Tony" <tony.luck@intel.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "David Woodhouse" <dwmw2@infradead.org>
In-Reply-To: <20080530204700.GA3807@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080528225136.GA29014@kroah.com>
	 <1FE6DD409037234FAB833C420AA843EC016FFF69@orsmsx424.amr.corp.intel.com>
	 <20080529003657.GA17505@kroah.com> <20080529010055.GA31952@redhat.com>
	 <20080529022632.GB5180@kroah.com>
	 <1FE6DD409037234FAB833C420AA843EC017405EB@orsmsx424.amr.corp.intel.com>
	 <20080530204700.GA3807@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2008 at 1:47 PM, Greg KH <greg@kroah.com> wrote:
...
> Well, you do know that the distribution of all of our users are:
>        50% only contributed 1 patch
>        25% contributed 2
>        12% contributed 3
>        6% contributed 4
> and so on?

"contributed" here means a patch was accepted.
This is measuring "attribution", not contribution.

Posting a patch is not trivial and (hopefully) takes a fair
amount of work to prepare for anyone not doing this full
time. I'm not talking about white space changes but
even trivial patches that require some testing.


It would be interesting to scrape the archives of linux-*
and netdev mailing lists to see who is submitting patches
(and how many) and compare that with how many the
same person gets "attribution" for. The fallout rate would
be a better indicator.

> Our curve is leveling out much better now though.  For the whole 2.5
> release, the top 30 people did over 80% of the work.  Now, the top 30
> people are doing 30% of the work.

My guess is top 30 people are spending more time reviewing patches
than writing code. They get "attribution" by adding their SOB lines.

> So it is getting much better, as long as we still continue to keep our
> massive rate of change[1] that we have going, and huge number of
> developers[2], we should be fine.
>
> So this list doesn't necessarily mean anything is wrong, only that 50%
> are one-time contributors.

In general I agree - I don't think the problem is as bad
as some people are claiming. But I want to acknowledge
it is a problem and I think jejb is right in how he is
raising the issue.

> And I think that shows we are easy to get a
> change into our tree from just about anyone, not that we are driving
> people away.

I still don't buy this. I've been contributing to linux kernel since about
1999 and it's definitely not getting easier.  The size of SubmittingPatches
is one indicator of how much work it is to submit a patch.
SubmittingPatches is now 600 lines (3400+ words).

The large number of contributors says nothing about how easy or hard
it is to get a patch into the tree. I think it says more about how many
people are getting paid to work on linux or are exposed to linux.

My own experience with tulip driver certainly isn't one that encourages
people to submit more patches and stay involved. USB patches I've
submitted were trivial (hard to debug and required specific HW to test)
but did get accepted. The first IDE patch I submitted also got rejected
with an answer that didn't help:
   http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg22756.html

That last patch "Worked For Me" and Alan Cox argued for it but it
didn't get further attention. I mention these only because except
for tulip, I wasn't paid to submit or work on those patches.

The problem is with specific maintainers not having BW or interest
in the users' problems. I'm thinking each maintainer should have
some "minions" to assist people submitting bugs/patches like
my issue with IDE until a patch gets accepted or the issue otherwise
resolved.

Another reason I suspect we are seeing more "one-time" contributions
is because of product development sticking with one kernel version
they've cooked themselves for several years.  The project will submit
fewer patches upstream as their kernel "ages" and each patch requires
substantial more work to "forward port". I don't expect there is anything
we can even if we could find volunteers to do that forward porting.

hth,
grant
