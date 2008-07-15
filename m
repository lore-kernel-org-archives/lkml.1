Return-Path: <linux-kernel-owner+w=401wt.eu-S1758825AbYGOOUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825AbYGOOUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 10:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbYGOOT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 10:19:59 -0400
Received: from winds.org ([68.75.195.9]:39422 "EHLO winds.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611AbYGOOT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 10:19:59 -0400
X-Greylist: delayed 756 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jul 2008 10:19:58 EDT
Date: Tue, 15 Jul 2008 10:07:21 -0400 (EDT)
From: Byron Stanoszek <bstanoszek@comtime.com>
X-X-Sender: gandalf@winds.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Stoyan Gaydarov <stoyboyker@gmail.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, gorcunov@gmail.com,
       akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: From 2.4 to 2.6 to 2.7?
In-Reply-To: <alpine.LFD.1.10.0807141914280.3017@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0807150938280.12665@winds.org>
References: <6d291e080807141910m573b29b2t753ea7c4db09902d@mail.gmail.com>
 <alpine.LFD.1.10.0807141914280.3017@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008, Linus Torvalds wrote:

> I think the time-based releases (ie the "2 weeks of merge window until -rc1,
> followed by roughly two months of stabilization") has been so successful that
> I'd prefer to skip the version numbering model too. We don't do releases
> based on "features" any more, so why should we do version _numbering_ based
> on "features"?
>
> For example, I don't see any individual feature that would merit a jump
> from 2.x to 3.x or even from 2.6.x to 2.8.x. So maybe those version jumps
> should be done by a time-based model too - matching how we actually do
> releases anyway.
>
> So if the version were to be date-based, instead of releasing 2.6.26,
> maybe we could have 2008.7 instead. Or just increment the major version
> every decade, the middle version every year, and the minor version every
> time we make a release. Whatever.

Well, we just haven't had anything big enough to merit an increase in the
minor number lately. I nominate the removal of the BKL as one such feature,
based on the sheer work required and how many modules you'll need to touch to
do so. In fact, it would be the natural conclusion to a 2.x series that
highlighted SMP as its primary new feature.

But it's hard now to predict future milestones, or when an overall paradigm
shift might happen. In those cases you'll want to give Linux a bright new
announcement to the world, instead of it being "just another standard year of
kernel development".

Remember, you used to have versions called 1.3.100 before -- and they seemed
perfectly normal back then. I personally like how we're still on 2.y.z numbers
compared to all of the other OSes (Solaris 11, HP-UX 11)...it makes Linux still
feel young, showing how much better it can get ;-)

So I vote for releasing by "features" still, and keep the current numbering
scheme. Who knows when the next big idea will pop up that's worthy of 3.0.0.

  -Byron

