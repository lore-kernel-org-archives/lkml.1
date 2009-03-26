Return-Path: <linux-kernel-owner+w=401wt.eu-S1754495AbZCZKBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbZCZKBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 06:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbZCZKBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 06:01:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58862 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbZCZKBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 06:01:24 -0400
Date: Thu, 26 Mar 2009 11:00:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [RFC][PATCH 2/3] perf_counter: executable mmap() information
Message-ID: <20090326100058.GD19826@elte.hu>
References: <20090325210419.408653980@chello.nl> <20090325210542.293237509@chello.nl> <18891.6159.109191.255560@drongo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18891.6159.109191.255560@drongo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> Peter Zijlstra writes:
> 
> > --- linux-2.6.orig/include/linux/perf_counter.h
> > +++ linux-2.6/include/linux/perf_counter.h
> > @@ -137,7 +137,9 @@ struct perf_counter_hw_event {
> >  				exclude_kernel :  1, /* ditto kernel          */
> >  				exclude_hv     :  1, /* ditto hypervisor      */
> >  				exclude_idle   :  1, /* don't count when idle */
> > -				include_tid    :  1, /* include the tid */
> > +				include_tid    :  1, /* include the tid       */
> > +				mmap           :  1, /* include mmap data     */
> > +				munmap         :  1, /* include munmap data   */
> >  
> >  				__reserved_1   : 54;
> 
> Nit: need to adjust the size of __reserved_1 here.  Or maybe just 
> get rid of it?

it's nice to have a constant reminder about how many bits there are 
left.

	Ingo
