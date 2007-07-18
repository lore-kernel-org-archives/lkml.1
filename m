Return-Path: <linux-kernel-owner+w=401wt.eu-S1765148AbXGROSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765148AbXGROSM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 10:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754614AbXGROR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 10:17:59 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:35468 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbXGROR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 10:17:58 -0400
X-Originating-Ip: 72.143.66.27
Date: Wed, 18 Jul 2007 10:15:59 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Jesper Juhl <jesper.juhl@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: other potential candidates for removal?
In-Reply-To: <9a8748490707180700t60bdbe88tb5190ade4e4f0c35@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0707181002010.22387@localhost.localdomain>
References: <Pine.LNX.4.64.0707180631400.23141@localhost.localdomain>
 <9a8748490707180700t60bdbe88tb5190ade4e4f0c35@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007, Jesper Juhl wrote:

> On 18/07/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> >
> >    a while back, i threw together this wiki page:
> >
> > http://fsdev.net/wiki/index.php?title=Stuff_to_be_removed
> >
> > feel free to comment.
> >
> Some comments on that list :
>
> } PCMCIA IOCTL support
> }
> } Currently listed in the removal file as scheduled for deletion back
> in November of 2005, but
> } there's some debate as to whether it's really ready to go.
>
> If you remove that don't you run the risk of breaking existing
> userspace (something which we don't do lightly) ?

sure but, once again, if that's the case, why is it still listed for
(long overdue) removal?  you could make the above argument for every
single feature in the removal file, and never be able to remove
*anything*.

> Same goes for other IOCTL's on the list as well as the ulog support.

i should point out that some of the content of that wiki page was
extracted from the Kconfig files themselves, where those features were
explicitly listed as obsolete.  from net/bridge/netfilter/Kconfig:

...
config BRIDGE_EBT_ULOG
        tristate "ebt: ulog support (OBSOLETE)"
...

in addition, note my comment on the wiki page -- that the help info
for that option even *mentions* that it's been obsoleted by a newer
feature.

> Also, some items seem to have made the list since they depend on
> BROKEN_ON_SMP or have no active maintainer.  As for depending on
> BROKEN_ON_SMP, as long as the drivers work fine on UP they may have
> users, so removing them would constitute regressions for those users
> - especially if there's no replacement driver. Wouldn't it be better
> to try and get those BROKEN_ON_SMP drivers to become SMP safe
> instead of just removing them (or just leave them as-is if they work
> for some people on UP)?

> As for the lack of an active maintainer being a partial reason for
> removal. I don't agree with that. As long as the code works and gets
> fixed up to continue working when other parts of the kernel evolve,
> then I see no reason to remove the code just because noone is
> actively maintaining it. Sometimes unmaintained code even grow new
> maintainers after a while.

your points are well taken.  i wasn't arguing *for* the removal of all
that stuff, i was simply asking for comments.  i can see adrian bunk
has already made some comments on the wiki page.  but if various
Kconfig entries explicitly advertise themselves as "OBSOLETE", that's
at least grounds for discussion as to whether it's time for something
to go.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
