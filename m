Return-Path: <linux-kernel-owner+w=401wt.eu-S1763539AbYA3RhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763539AbYA3RhI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 12:37:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758144AbYA3Rgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 12:36:43 -0500
Received: from www.tglx.de ([62.245.132.106]:40860 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756801AbYA3Rgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 12:36:42 -0500
Date: Wed, 30 Jan 2008 18:36:12 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: hrtimers and lockdep (was: Re: 2.6.24-rc6: possible recursive
 locking detected)
In-Reply-To: <1201689272.28547.204.camel@lappy>
Message-ID: <alpine.LFD.1.00.0801301835050.9204@apollo.tec.linutronix.de>
References: <alpine.DEB.0.999999.0801032349190.4821@sheep.housecafe.de>  <200801040006.47979.rjw@sisk.pl> <20080104083049.GC22803@elte.hu>  <20080105071205.GA28936@gondor.apana.org.au>  <1199552016.31975.41.camel@lappy> <1199552476.31975.45.camel@lappy> 
 <20080107172239.GA14880@tv-sign.ru> <20080107174908.GB14880@tv-sign.ru>  <1200241927.7999.38.camel@lappy>  <20080114212741.GA2263@tv-sign.ru> <1201689272.28547.204.camel@lappy>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2008, Peter Zijlstra wrote:

> ( trimmed CC list )
> 
> Sorry for the delay, this message seems to have gotten lost in my
> inbox :-/
> 
> On Tue, 2008-01-15 at 00:27 +0300, Oleg Nesterov wrote:
> > On 01/13, Peter Zijlstra wrote:
> 
> > Offtopic question. Why do we have so many lockdep stuff in timer.c and hrtimer.c ?
> > We never lock 2 bases at the same time, except in migrate_timers(). We can kill
> > double_spin_lock() and base_lock_keys[] and just use spin_lock_nested in
> > migrate_timers(), no?
> 
> Lets ask Thomas.. :-)

No objections as long as it all works :)

   tglx
