Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbYKTJIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbYKTJIE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 04:08:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbYKTJHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 04:07:46 -0500
Received: from tallyho.bytemark.co.uk ([80.68.81.166]:43959 "EHLO
	tallyho.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbYKTJHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 04:07:45 -0500
Date: Thu, 20 Nov 2008 09:07:37 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Julia Lawall <julia@diku.dk>
Subject: Re: gitwatch: RSS feed of checkpatch+coccinelle against new
	commits in mainline
Message-ID: <20081120090737.GE14274@shadowen.org>
References: <19f34abd0811181420i2b582fd2jcaa685b0cbb5c979@mail.gmail.com> <20081120082639.GC14274@shadowen.org> <19f34abd0811200057n73cfae6va5efc1d91bc438e4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0811200057n73cfae6va5efc1d91bc438e4@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 09:57:14AM +0100, Vegard Nossum wrote:
> On Thu, Nov 20, 2008 at 9:26 AM, Andy Whitcroft <apw@shadowen.org> wrote:
> > On Tue, Nov 18, 2008 at 11:20:48PM +0100, Vegard Nossum wrote:
> >> I've written a script that follows the mainline git repository and
> >> runs checkpatch against all new commits. The result is available as an
> >> RSS stream:
> >>
> >>     http://kernel.org/~vegard/gitwatch.rss
> >>
> >> Only commits with warnings or errors are shown. Files that change are
> >> also searched for known/frequent coding errors using Coccinelle and a
> >> selection of the semantic patches found on the Coccinelle website.
> >
> > Thats pretty intresting.  Looking at some of the cochinelle output I am
> > a little confused as to what its saying.  Am I right in thinking that
> > for those reports that a proposed patch is printed, after the comment
> > for the original patch?  If so it might be helpful to say something like
> > 'proposed modificiation' just before the patchlet.
> 
> You are correct, those are the modifications that would have been made
> by the semantic patch. I agree, it might look like the log text
> belongs to the patch below, which is wrong. We are also planning to
> add a description to each of the semantic patches so that a better
> explanation is given for the change.

Yes a "You should use NULL not 0" before the patch would make it clearer
for sure.

> > Also which version of checkpatch is this output being generated with?
> > The one at the head of the git tree or something else?  I see a couple
> > of false positives in there that I know I have fixed already.
> 
> Yes, it's a copy of the one in linux-2.6.git (after v2.6.28-rc4). The
> file itself says 0.24. Which false positives were you thinking about?

There are a couple in there, one is a comment tracking issue and there
is one on ':' tracking for things of this form:

	int foo:1,
	    bar:2,
	    baz:1;

Fixes for these are in my tree, not sure if Andrew has them yet.  I am
a little behind and intending on rolling up a new block of changes this
week.

-apw
