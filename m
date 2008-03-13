Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbYCMSDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbYCMSDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 14:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756338AbYCMSDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 14:03:05 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47352 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086AbYCMSDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 14:03:03 -0400
Date: Thu, 13 Mar 2008 19:03:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Fred ." <eldmannen@gmail.com>
Cc: David Newall <davidn@davidnewall.com>, Jiri Kosina <jkosina@suse.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: Keys get stuck
Message-ID: <20080313180333.GB4949@elf.ucw.cz>
References: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com> <Pine.LNX.4.64.0803121131200.7266@twin.jikos.cz> <47D7B428.6010804@davidnewall.com> <20080313171425.GA4840@ucw.cz> <f188924b0803131056m2aae7625x24bd00136b712076@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f188924b0803131056m2aae7625x24bd00136b712076@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-03-13 18:56:04, Fred . wrote:
> With so many people suffering from this bug (for a long time), and so
> many bright people here, why doesn't it get fixed?

With so many trolls out here it is hard to get any real work done.

> ...other operating systems don't suffer from this bug...

X is broken here... feel free to fix it. You could also test
2.6.25-rc4, perhaps it is fixed there? Disable GROUP_SCHED.

								Pavel

> On Thu, Mar 13, 2008 at 6:14 PM, Pavel Machek <pavel@ucw.cz> wrote:
> >
> > On Wed 2008-03-12 21:14:56, David Newall wrote:
> >  > Jiri Kosina wrote:
> >  > > Very probably this is due to broken way how X themselves implement
> >  > > auto-repeat, instead of using kernel-provided auto-repeat functionality.
> >  >
> >  > It should be said that X implements auto-repeat out of necessity.  While
> >  > the kernel can report key down and up events, its further interpretation
> >  > of those events is not appropriate.  Many combinations of events are
> >  > possible, such as keyboard plus mouse, and this precludes the kernel
> >  > from providing a full interpretation.  It would be wrong for it to even
> >  > try.  X is the proper place to implement auto-repeat for X.
> >
> >  No.
> >
> >  hw is proper place to implement autorepeat, and along with some
> >  buffering, it has chance to work. Kernel is not real-time, and X are
> >  definitely not real-time, while autorepeat is real-time operation.
> >
> >  It actually mostly works in ps/2 case. Buffer in hardware means that
> >  pretty big interrupt delays can be tolerated without problems.
> >
> >  --
> >  (english) http://www.livejournal.com/~pavelmachek
> >  (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> >

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
