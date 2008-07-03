Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbYGCT5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbYGCT5N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 15:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753647AbYGCT46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 15:56:58 -0400
Received: from www.tglx.de ([62.245.132.106]:52071 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405AbYGCT45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 15:56:57 -0400
Date: Thu, 3 Jul 2008 21:55:38 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Paul Mundt <lethal@linux-sh.org>
Cc: "Hans J. Koch" <hjk@linutronix.de>,
       Uwe Kleine-K??nig <Uwe.Kleine-Koenig@digi.com>,
       Magnus Damm <magnus.damm@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] uio: User IRQ Mode
Message-ID: <20080703195538.GC3197@local>
References: <20080702105951.22648.2197.sendpatchset@rx1.opensource.se> <20080702125400.GC3199@local> <20080703071019.GC12214@digi.com> <20080703124505.GB3197@local> <20080703132316.GA1040@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080703132316.GA1040@linux-sh.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2008 at 10:23:16PM +0900, Paul Mundt wrote:
> On Thu, Jul 03, 2008 at 02:45:05PM +0200, Hans J. Koch wrote:
> > On Thu, Jul 03, 2008 at 09:10:19AM +0200, Uwe Kleine-K??nig wrote:
> > > 	  Moreover this might prevent some bugs.  (And obviously this
> > > 	  function has the potential to have a buggy implementation as
> > > 	  the comment by Alan Cox shows.)
> > 
> > For me, this shows two things:
> > 
> > - I never ever had to use disable_irq_nosync() in any UIO driver yet,
> >   otherwise I would have noticed.
> > 
> > - Magnus turned in a patch that he never tested.
> > 
> Note that the deadlock in question is in relation to SMP, it's true that
> the patch was never tested in an SMP environment and only on UP, but it
> certainly was tested.

Ok, so I take back that accusation ;-)
Nonetheless, the patch changes a UIO core file, and everything in there
should work in all situations on all architectures unless there is a
_very_ good reason to do something different. This not only applies to
SMP issues but also to the limitation to non-shared interrupts.

> The vast majority of driver writers don't have a
> need to use disable_irq_nosync(), so whether you've had to use it or not
> is largely irrelevant to the conversation at hand ;-)

Sure ;-) I merely wanted to point out that this is an unusual way to
handle an interrupt.

Thanks,
Hans

