Return-Path: <linux-kernel-owner+w=401wt.eu-S1758892AbYA3Keu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892AbYA3Keu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 05:34:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755834AbYA3Kek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 05:34:40 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53906 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308AbYA3Kej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 05:34:39 -0500
Subject: hrtimers and lockdep (was: Re: 2.6.24-rc6: possible recursive
	locking detected)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080114212741.GA2263@tv-sign.ru>
References: <alpine.DEB.0.999999.0801032349190.4821@sheep.housecafe.de>
	 <200801040006.47979.rjw@sisk.pl> <20080104083049.GC22803@elte.hu>
	 <20080105071205.GA28936@gondor.apana.org.au>
	 <1199552016.31975.41.camel@lappy> <1199552476.31975.45.camel@lappy>
	 <20080107172239.GA14880@tv-sign.ru> <20080107174908.GB14880@tv-sign.ru>
	 <1200241927.7999.38.camel@lappy>  <20080114212741.GA2263@tv-sign.ru>
Content-Type: text/plain
Date: Wed, 30 Jan 2008 11:34:32 +0100
Message-Id: <1201689272.28547.204.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

( trimmed CC list )

Sorry for the delay, this message seems to have gotten lost in my
inbox :-/

On Tue, 2008-01-15 at 00:27 +0300, Oleg Nesterov wrote:
> On 01/13, Peter Zijlstra wrote:

> Offtopic question. Why do we have so many lockdep stuff in timer.c and hrtimer.c ?
> We never lock 2 bases at the same time, except in migrate_timers(). We can kill
> double_spin_lock() and base_lock_keys[] and just use spin_lock_nested in
> migrate_timers(), no?

Lets ask Thomas.. :-)

