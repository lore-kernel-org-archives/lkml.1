Return-Path: <linux-kernel-owner+w=401wt.eu-S1758672AbZDKS61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672AbZDKS61 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 14:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757144AbZDKS6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 14:58:17 -0400
Received: from www.tglx.de ([62.245.132.106]:45599 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757015AbZDKS6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 14:58:17 -0400
Date: Sat, 11 Apr 2009 20:57:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dimitri Sivanich <sivanich@sgi.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2] Move calc_load call out from xtime_lock protection
In-Reply-To: <20090411171504.GA4132@sgi.com>
Message-ID: <alpine.LFD.2.00.0904112056240.21577@localhost.localdomain>
References: <20090410173437.GA23415@sgi.com> <alpine.LFD.2.00.0904110931240.21577@localhost.localdomain> <20090411162416.GC3496@sgi.com> <alpine.LFD.2.00.0904111849450.21577@localhost.localdomain> <20090411171504.GA4132@sgi.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dimitri,

On Sat, 11 Apr 2009, Dimitri Sivanich wrote:
> > 
> > /me goes back to stare a bit more at the avenrun stuff
> > 
> Also, if my patch gets replaced by this, you might want to avoid
> saving intermediate results in calc_load, as my patch attempts to
> do.

Good point. Thanks for the reminder.

     tglx
