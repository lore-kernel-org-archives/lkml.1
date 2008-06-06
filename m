Return-Path: <linux-kernel-owner+w=401wt.eu-S1759199AbYFFOqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759199AbYFFOqj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 10:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757105AbYFFOq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 10:46:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49537 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756905AbYFFOq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 10:46:26 -0400
Subject: Re: [Ksummit-2008-discuss] RFC: Moving firmware blobs out of the
	kernel.
From: David Woodhouse <dwmw2@infradead.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       David Miller <davem@davemloft.net>,
       James.Bottomley@HansenPartnership.com,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080601161715.GB5555@ucw.cz>
References: <1212077700.26088.83.camel@shinybook.infradead.org>
	 <20080529164745.GA21763@kroah.com> <483F1232.4010003@linux.intel.com>
	 <20080529.140919.160813310.davem@davemloft.net>
	 <483F1C17.8040207@linux.intel.com>
	 <1212102258.20303.6.camel@shinybook.infradead.org>
	 <20080601161715.GB5555@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 06 Jun 2008 15:46:15 +0100
Message-Id: <1212763575.32207.333.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-06-01 at 18:17 +0200, Pavel Machek wrote:
> Hi!
> 
> > The firmware is an independent and separate work in itself. Section 2 of
> > the GPL talks about such sections of the work, explicitly. The only way
> > to excuse what we're doing at the moment is to call it 'mere
> > aggregation' -- an exception which was intended to handle stuff like the
> > 'freeware' CDs on the covers of magazines, distributing a bunch of
> > unrelated software. Not a coherent work combining software from
> > different sources into a single entity which works closely together as
> > one, and where one part is useless without the other.
> 
> Wait a moment, haven't you just described linux distribution?
> 
> I mean, if aggregation clause does not work for firmware in kernel,
> why would it work for packages in distro?
>
> (Actually, seeing some distro EULAs, I wished GPL infected whole
> distro so that I'd not have to read the stupid EULA.)

That's an interesting question, which has concerned me in the past. 
There are certainly those who would claim that the distribution _is_ a
collective work, and not just 'mere aggregation on a volume of a storage
or distribution medium'. Which poses interesting questions.

I think you might _just_ about get away with arguing to the contrary, as
long as you never refer to the distribution as a collective work which
is copyrightable in its own right, or try to put a EULA on it or
anything like that. At least it's _slightly_ more excusable in that case
than what we were talking about before.

Again, there's no definitive answer until/unless it comes to court. But
there's no _guarantee_ that a court would rule that what we're doing is
OK, even though it's a long-standing and universally accepted practice.
You can't apply reductio ad absurdum and declare that the whole
'collective work' part of §2 doesn't exist just because it might lead to
a _really_ surprising conclusion.

> > There are people who own copyright on firmware who refuse to put it into
> > the Linux source tree, because their lawyers don't believe the 'mere
> > aggregation' line, and believe that including it in the kernel source in
> > any form would require them to license it under the GPL.
> 
> They can release the firmware under BSD 3-clause, and we can include
> it in kernel, then.... right? (Or into linux-firmware or into whatever
> package that comes handy).

You may only include it in a GPL'd project if you can distribute the
source code in the preferred form for editing -- unless you claim that
the tightly intertwined combination of driver and firmware is "mere
aggregation on a volume of a storage medium", which many would say it
blatantly is not.

If, on the other hand, we have a separate repository where stuff only
has to be 'redistributable', then that would be OK even without source.

I'm working on reducing the technical barriers to having a separate
repository, to the point where it becomes silly not to do it like that.

-- 
dwmw2

