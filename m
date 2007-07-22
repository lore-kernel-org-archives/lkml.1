Return-Path: <linux-kernel-owner+w=401wt.eu-S1760703AbXGVOsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760703AbXGVOsW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 10:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbXGVOsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 10:48:11 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:55774 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474AbXGVOsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 10:48:10 -0400
Date: Sun, 22 Jul 2007 16:49:23 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [DRIVER SUBMISSION] DRBD wants to go mainline
Message-ID: <20070722144923.GA28958@uranus.ravnborg.org>
References: <20070721203819.GA10706@mail.linbit.com> <p73hcnxuxji.fsf@bingen.suse.de> <20070722055235.GQ11657@kernel.dk> <20070722135814.GA32371@mail.linbit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070722135814.GA32371@mail.linbit.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2007 at 03:58:14PM +0200, Lars Ellenberg wrote:
> On Sun, Jul 22, 2007 at 07:52:36AM +0200, Jens Axboe wrote:
> > On Sun, Jul 22 2007, Andi Kleen wrote:
> > > Lars Ellenberg <lars@linbit.com> writes:
> > > > 
> > > > Jens, Andrew, anyone: please review,
> > > > and give me advice how to proceed from here.
> > > 
> > > The standard procedure would be to post all the source code in logical
> > > pieces on the list for review. Then iterate until all comments are
> > > addressed.
> > 
> > Yep, cleanup the style issues (that make sense) from checkpatch and then
> > psot as a series of patches that can be reviewed. Linking to a git tree
> > wont get you very far.
> 
> it got me far enough, for the first try, anyways :-)
> I did not spam the lkml with patches, and still got some very useful
> advice (no idea how I could overlook the checkpatch.pl complaints).
> 
> If each patch of a series needs to compile and work,
> there will probably only one 17kB patch...
Thats not needed for reviewing..

> 33 WARNING: line over 80 characters
>     hmmm. get more ugly...
>     probably need some helper functions and temp variables?

Several people question this check. It gets ugly on text-mode but for
the price of readability for the rest.
So I suggest concentrate on other matters, but keep an eye for the
"many small functions that do exactly _one_ thing and few local variables"
approach.

	Sam
