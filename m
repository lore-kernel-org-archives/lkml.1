Return-Path: <linux-kernel-owner+w=401wt.eu-S1757968AbXJCLSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968AbXJCLSB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 07:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640AbXJCLRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 07:17:53 -0400
Received: from mx12.go2.pl ([193.17.41.142]:59472 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754272AbXJCLRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 07:17:52 -0400
Date: Wed, 3 Oct 2007 13:20:25 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, David Schwartz <davids@webmaster.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Network slowdown due to CFS
Message-ID: <20071003112025.GA3495@ff.dom.local>
References: <20071002060607.GA18588@elte.hu> <20071003080224.GB1726@ff.dom.local> <20071003081613.GA29904@elte.hu> <20071003085636.GC1726@ff.dom.local> <20071003091058.GB7802@elte.hu> <20071003095057.GD1726@ff.dom.local> <b647ffbd0710030355p116f9b36vae3f24e652921de6@mail.gmail.com> <b647ffbd0710030358m3b107176n5f52e7b7846ef1d8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0710030358m3b107176n5f52e7b7846ef1d8@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2007 at 12:58:26PM +0200, Dmitry Adamushko wrote:
> On 03/10/2007, Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
> > On 03/10/2007, Jarek Poplawski <jarkao2@o2.pl> wrote:
> > > I can't see anything about clearing. I think, this was about charging,
> > > which should change the key enough, to move a task to, maybe, a better
> > > place in a que (tree) than with current ways.
> >
> > just a quick patch, not tested and I've not evaluated all possible
> > implications yet.
> > But someone might give it a try with his/(her -- are even more
> > welcomed :-) favourite sched_yield() load.
> >
> > (and white space damaged)
> >
> > --- sched_fair-old.c    2007-10-03 12:45:17.010306000 +0200
> > +++ sched_fair.c        2007-10-03 12:44:46.899851000 +0200
...
> s/curr/se

Thanks very much!

Alas, I'll be able to look at this and try only in the evening.

Best regards,
Jarek P.
