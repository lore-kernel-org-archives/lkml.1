Return-Path: <linux-kernel-owner+w=401wt.eu-S2992490AbXDELPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992490AbXDELPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 07:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992504AbXDELPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 07:15:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50883 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992490AbXDELPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 07:15:42 -0400
Date: Thu, 5 Apr 2007 13:15:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Con Kolivas <kernel@kolivas.org>,
       linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
Subject: Re: [PATCH] sched: staircase deadline misc fixes
Message-ID: <20070405111521.GA16677@elte.hu>
References: <200703290237.38777.kernel@kolivas.org> <200703290944.45888.kernel@kolivas.org> <1175147455.6430.91.camel@Homer.simpson.net> <200704031237.21946.kernel@kolivas.org> <1175578270.6342.12.camel@Homer.simpson.net> <20070403060109.GA6708@elte.hu> <1175770950.6609.16.camel@Homer.simpson.net> <20070405110911.GA14803@elte.hu> <1175771555.6609.17.camel@Homer.simpson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175771555.6609.17.camel@Homer.simpson.net>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> > -	 */ 
> > +	 */
> >  	if (now < p->timestamp || batch_task(p))
> >  		sleep_time = 0;
> >  
> 
> Thanks.
> 
> (dang, i need to find that fifty "make it red" thingie for vi again)

or just start using quilt, which warns about this :)

	Ingo
