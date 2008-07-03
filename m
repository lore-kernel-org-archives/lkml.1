Return-Path: <linux-kernel-owner+w=401wt.eu-S1756274AbYGCN00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274AbYGCN00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 09:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbYGCN0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 09:26:16 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:43212 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751718AbYGCN0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 09:26:15 -0400
Date: Thu, 3 Jul 2008 22:23:16 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Uwe Kleine-K??nig <Uwe.Kleine-Koenig@digi.com>,
       Magnus Damm <magnus.damm@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] uio: User IRQ Mode
Message-ID: <20080703132316.GA1040@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	"Hans J. Koch" <hjk@linutronix.de>,
	Uwe Kleine-K??nig <Uwe.Kleine-Koenig@digi.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>
References: <20080702105951.22648.2197.sendpatchset@rx1.opensource.se> <20080702125400.GC3199@local> <20080703071019.GC12214@digi.com> <20080703124505.GB3197@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080703124505.GB3197@local>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2008 at 02:45:05PM +0200, Hans J. Koch wrote:
> On Thu, Jul 03, 2008 at 09:10:19AM +0200, Uwe Kleine-K??nig wrote:
> > 	  Moreover this might prevent some bugs.  (And obviously this
> > 	  function has the potential to have a buggy implementation as
> > 	  the comment by Alan Cox shows.)
> 
> For me, this shows two things:
> 
> - I never ever had to use disable_irq_nosync() in any UIO driver yet,
>   otherwise I would have noticed.
> 
> - Magnus turned in a patch that he never tested.
> 
Note that the deadlock in question is in relation to SMP, it's true that
the patch was never tested in an SMP environment and only on UP, but it
certainly was tested. The vast majority of driver writers don't have a
need to use disable_irq_nosync(), so whether you've had to use it or not
is largely irrelevant to the conversation at hand ;-)
