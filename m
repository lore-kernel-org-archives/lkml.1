Return-Path: <linux-kernel-owner+w=401wt.eu-S1757861AbYHVA1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861AbYHVA1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 20:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbYHVA04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 20:26:56 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:52392 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbYHVA0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 20:26:55 -0400
Date: Thu, 21 Aug 2008 17:26:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: lkml <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
Subject: Re: in 2.6.23-rc3-git7 in do_cciss_intr
Message-Id: <20080821172653.3e3e855c.randy.dunlap@oracle.com>
In-Reply-To: <0F5B06BAB751E047AB5C87D1F77A778835118100D6@GVW0547EXC.americas.hpqcorp.net>
References: <48AD02B2.7020004@oracle.com>
	<0F5B06BAB751E047AB5C87D1F77A778835116209D3@GVW0547EXC.americas.hpqcorp.net>
	<20080821084333.c471b439.randy.dunlap@oracle.com>
	<0F5B06BAB751E047AB5C87D1F77A7788351181004C@GVW0547EXC.americas.hpqcorp.net>
	<20080821091514.8f56e2d5.randy.dunlap@oracle.com>
	<0F5B06BAB751E047AB5C87D1F77A778835118100D6@GVW0547EXC.americas.hpqcorp.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2008 16:25:24 +0000 Miller, Mike (OS Dev) wrote:

> > >
> > > Randy,
> > > We know of a race condition in cciss_init_one. It's fixed
> > in 2.6.26 I believe. Here's the patch:
> > >
> > >
> > http://groups.google.com/group/linux.kernel/browse_thread/thread/7b39f
> > > 2b77622ab03/4f5f45c008655ca1?hl=en&lnk=gst&q=cciss#4f5f45c008655ca1
> >
> >
> > Mike,
> > Sorry, but my fingers have typoed the $subject.  My bad.
> > Kernel is 2.6.27-rc3-git7 (from above):
> >
> > > > > > Modules linked in: cciss(+) ehci_hcd ohci_hcd uhci_hcd
> > > > > > Pid: 0, comm: swapper Not tainted 2.6.27-rc3-git7 #1
> > > > > > RIP: 0010:[<ffffffffa001bb68>]  [<ffffffffa001bb68>]
> > > > > > do_cciss_intr+0x627/0xa6c [cciss]
> >
> Hmmmmm, let me know what happens from your retest. I'll look at this as soon as I finish what I'm doing now. We trying to spin for our test teams but I have something hopelessly broken. :(

It didn't BUG in the retest.  That just means that it's more difficult
to find/fix, right?

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
