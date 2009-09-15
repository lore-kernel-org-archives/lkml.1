Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbZIOLd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbZIOLd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 07:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbZIOLdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 07:33:53 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49307 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbZIOLdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 07:33:53 -0400
Date: Tue, 15 Sep 2009 13:33:47 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@opfer-online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch for 2.6.31] zaurus c3000 aka spitz: fix resume
Message-ID: <20090915113347.GC1328@ucw.cz>
References: <20090909075024.GA1400@ucw.cz> <f17812d70909090737n4315d0cbh82c0a63e9222fdb5@mail.gmail.com> <20090909182340.GA5235@n2100.arm.linux.org.uk> <20090910191932.GA23721@elf.ucw.cz> <20090910224159.GA4360@n2100.arm.linux.org.uk> <f17812d70909101819o2467c5a6jf65579cd9aebb1e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f17812d70909101819o2467c5a6jf65579cd9aebb1e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-09-11 09:19:19, Eric Miao wrote:
> On Fri, Sep 11, 2009 at 6:41 AM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Thu, Sep 10, 2009 at 09:19:32PM +0200, Pavel Machek wrote:
> >> On Wed 2009-09-09 19:23:40, Russell King - ARM Linux wrote:
> >> > On Wed, Sep 09, 2009 at 10:37:41PM +0800, Eric Miao wrote:
> >> > > On Wed, Sep 9, 2009 at 3:50 PM, Pavel Machek<pavel@ucw.cz> wrote:
> >> > > > Hi, Linus!
> >> > > >
> >> > > > Spitz resume was broken for year or likely two, and it would be very
> >> > > > nice to fix it for 2.6.31 release. One liner is below, and it really
> >> > > > can not harm. It already is in Eric's fix queue, so pulling that for
> >> > > > .31 should work, too.
> >> > > >
> >> > >
> >> > > This should be sitting in rmk's git tree and I'm not sure if Russell
> >> > > has sent the pull request already.
> >> >
> >> > It's just Pavel being his obnoxious impatient self...
> >>
> >> Aha, Russell, being polite and helpful, as usual.
> >>
> >> Only that, you know, you missed the deadline, so... perhaps I had
> >> reason to be impatient?
> >
> > I missed the deadline because I was waiting on others to sort out telling
> > me whether a bugfix patch was actually correct, and then it took several
> > days and mails to get an attributation line out of them. ??I finally got
> > that yesterday, and since I'm not doing kernel work (in fact, I'm hardly
> > in front of the computer at the moment) these things are going to _HAVE_
> > to wait until this weekend.
> >
> > By agreement with Linus, I do not send pull requests more often than once
> > a week, absolute maximum. ??So if I've something pending in the queue, I
> > hold off sending the queue until that issue is resolved.
> >
> > Don't like it? ??Tough. ??This is the workflow that I've been forced into
> > by other flame wars. ??It would be my personal preference to ensure that
> > fixes make their way in a timely manner into mainline, but due to that,
> > it's just not possible.
> >
> 
> Pavel,
> 
> It is still possible to get this into the stable release so take easy.

Ok, so can you (or Russell?) add cc: stable@kernel.org header so that
stable is notified when patch is merged?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
