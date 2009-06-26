Return-Path: <linux-kernel-owner+w=401wt.eu-S1760258AbZFZQHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760258AbZFZQHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 12:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbZFZQHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 12:07:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:45664 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbZFZQHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 12:07:09 -0400
Subject: Re: [PATCH -tip] perf_counter tools: shorten names for events
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Roland Dreier <rdreier@cisco.com>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090625153406.GA12918@elte.hu>
References: <1245760130.3776.6.camel@localhost.localdomain>
	 <20090623195656.GC8777@elte.hu>
	 <1245876060.3038.7.camel@localhost.localdomain>
	 <20090625093346.GD23547@elte.hu> <1245934522.5308.39.camel@hpdv5.satnam>
	 <ada3a9ol58t.fsf@cisco.com>  <20090625153406.GA12918@elte.hu>
Content-Type: text/plain
Date: Fri, 26 Jun 2009 21:36:39 +0530
Message-Id: <1246032399.3063.3.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-25 at 17:34 +0200, Ingo Molnar wrote:
> * Roland Dreier <rdreier@cisco.com> wrote:
> 
> >  >       266590464  L1d-loads             (scaled from 23.03%)
> > 
> > IMHO "L1d" is too abbreviated for it to be obvious that it means 
> > L1 data cache.  If you want something really short maybe "L1-d$" 
> > might be a little clearer, but I stil like "L1-dcache" best.
> 
> i changed it to L1-d$ / L1-i$.
> 
> > The formatting of aligning things is nice defitely but we could 
> > also shorten lines by saying "scaled from" in fewer characters 
> > maybe?  (I have to admit I don't know what "scaled from X%" means 
> > in this case so I can't suggest something better, but the fact 
> > that I can't easily tell what it means probably suggests that the 
> > wording could be improved)
> 
> Indeed, the '(scaled from 12.3%)' message should i guess be changed 
> to:
> 
>   (9.43x scaled)
> 
> ( and a multiplicative factor is more expressive anyway, than the 
>   percentage of from where we scale up. )
> 

Can you please let me know how you get 9.43x from 12.3%

Thanks,
--
JSR



