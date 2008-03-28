Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbYC1QTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbYC1QTF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 12:19:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbYC1QSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 12:18:54 -0400
Received: from www.tglx.de ([62.245.132.106]:36164 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863AbYC1QSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 12:18:53 -0400
Date: Fri, 28 Mar 2008 17:18:11 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Venkatesch Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
In-Reply-To: <200803281712.05432.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.00.0803281714470.3781@apollo.tec.linutronix.de>
References: <200803272353.51901.rjw@sisk.pl> <alpine.LFD.1.00.0803281004440.3781@apollo.tec.linutronix.de> <200803281712.05432.rjw@sisk.pl>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Mar 2008, Rafael J. Wysocki wrote:
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10153
> > > Subject		: (regression) kernel/timeconst.h bugs with HZ=128
> > > Submitter	: David Brownell <david-b@pacbell.net>
> > > Date		: 2008-02-26 19:32 (31 days old)
> > > References	: http://lkml.org/lkml/2008/2/26/294
> > > Handled-By	: H. Peter Anvin <hpa@zytor.com>
> > > Patch		: http://bugzilla.kernel.org/attachment.cgi?id=15114&amp;action=view
> > > 		  http://bugzilla.kernel.org/attachment.cgi?id=15115&amp;action=view
> > 
> > Have those patches made it somewhere else than into the bugzilla ?
> 
> I don't think so.

They touch a bunch of files but they are pretty straight forward and
obvious. OTOH HZ=128 is not really anyway near to a default config and
I think we can safely postpone that one to .26

@hpa: can you please post them on LKML so they don't settle dust in
the bugzilla ?

Thanks,
	tglx
