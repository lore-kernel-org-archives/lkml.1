Return-Path: <linux-kernel-owner+w=401wt.eu-S1755015AbYHAKgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbYHAKgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 06:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbYHAKgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 06:36:42 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:43205 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbYHAKgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 06:36:41 -0400
Message-ID: <4892E703.8060507@s5r6.in-berlin.de>
Date: Fri, 01 Aug 2008 12:35:47 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: "Randy.Dunlap" <rdunlap@xenotime.net>
CC: Daniel Barkalow <barkalow@iabervon.org>, Jonathan Corbet <corbet@lwn.net>,
       Alex Chiang <achiang@hp.com>, LKML <linux-kernel@vger.kernel.org>,
       Amanda McPherson <amanda@amcpherson.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, RFC] A development process document
References: <20080729143015.0f79cf37@bike.lwn.net> <20080731062305.GA18070@ldl.fc.hp.com> <20080731101738.1bf4281c@bike.lwn.net> <alpine.LNX.1.00.0807311249320.19665@iabervon.org> <Pine.LNX.4.64.0807311055400.6503@shark.he.net>
In-Reply-To: <Pine.LNX.4.64.0807311055400.6503@shark.he.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy.Dunlap wrote:
> On Thu, 31 Jul 2008, Daniel Barkalow wrote:
>> On Thu, 31 Jul 2008, Jonathan Corbet wrote:
>> > On Thu, 31 Jul 2008 00:23:05 -0600
>> > Alex Chiang <achiang@hp.com> wrote:
>> > > > +If you have a significant series of patches, it is customary to
>> > > > send an +introductory description as part zero.  In general, the
>> > > > second and
>> > > 
>> > > This directly conflicts with akpm's advice:
>> > > 
>> > > 	http://www.zipworld.com.au/~akpm/linux/patches/stuff/tpp.txt
>> > > 
>> > > Section 6(b).
>> > 
>> > Interesting; Andrew didn't mention that in his review.  I think the intro
>> > postings can be very useful in understanding a patch series as a whole.
>> > Maybe I'll put in something about how anything which should be in the
>> > changelogs needs to go with the actual patches.
>> 
>> If you include a [0/N], it's a cover letter, not a changelog portion. It 
>> can be a useful way of providing context to reviewers as to the intended 
>> total effect. Each of the patches should make sense standalone, but it's 
>> not always clear from the individual patches what the total benefit is, 
>> and a 0/N that explains can be worthwhile (and you'd want to make that 
>> announcement to the mailing list, but not get it into the history).
> 
> but.. but Andrew often has to take part(s) of #0/N and add them to the
> changelog(s) to make the changelog(s) meaningful.  I.e., someone skimped
> on what should have been in the changelog(s).

That would not be a problem with the cover posting, it would be a
problem with the changelogs.  The same applies if the respective
information is put below the '---' delimiter line in the individual
patch postings.  So just remember that changelogs need to be
sufficiently comprehensive even when read standalone, out of the context
of the series.

BTW, I always like to see the -> combined diffstat <- of the whole patch
series in 0/N cover postings.  For this reason alone, a cover posting is
IMO generally recommendable for series of more than three or four
patches.  Especially if the reason for posting is a request for review
rather than transfer to a maintainer.

I think Andrew's advice in tpp is very valid in order to create "the
perfect patch", but not really how to post "the perfect review request".
-- 
Stefan Richter
-=====-==--- =--- ----=
http://arcgraph.de/sr/
