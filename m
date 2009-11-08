Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbZKHQMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbZKHQMK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 11:12:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753935AbZKHQMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 11:12:09 -0500
Received: from www.tglx.de ([62.245.132.106]:41147 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901AbZKHQMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 11:12:08 -0500
Date: Sun, 8 Nov 2009 17:11:52 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Kyle McMartin <kyle@mcmartin.ca>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-parisc@vger.kernel.org
Subject: Re: [patch 10/16] parisc: Replace old style lock init
In-Reply-To: <20091108050614.GB28962@bombadil.infradead.org>
Message-ID: <alpine.LFD.2.00.0911081710560.2725@localhost.localdomain>
References: <20091106223547.784916750@linutronix.de> <20091106223806.803538964@linutronix.de> <20091108050614.GB28962@bombadil.infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Nov 2009, Kyle McMartin wrote:

> On Fri, Nov 06, 2009 at 10:41:51PM -0000, Thomas Gleixner wrote:
> > SPIN_LOCK_UNLOCKED is deprecated. Init the per cpu locks at runtime
> > instead.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Kyle McMartin <kyle@mcmartin.ca>
> > Cc: linux-parisc@vger.kernel.org
> 
> applied with one nit.
> 
> >  
> > -DEFINE_SPINLOCK(smp_lock);
> > -
> 
> You forgot to mention this was unused. :) Confused me for a while.

Gah. Wanted to add it to the changelog, but slipped from my mind.

Sorry for the confusion,

	tglx
