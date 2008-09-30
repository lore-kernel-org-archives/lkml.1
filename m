Return-Path: <linux-kernel-owner+w=401wt.eu-S1753435AbYI3LWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbYI3LWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 07:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbYI3LVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 07:21:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33677 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468AbYI3LVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 07:21:52 -0400
Date: Tue, 30 Sep 2008 13:21:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [patch 1/2] x86: track memtype for RAM in page struct - v3
Message-ID: <20080930112128.GB21367@elte.hu>
References: <20080913000003.732756000@linux-os.sc.intel.com> <48D966AE.1040008@linux-foundation.org> <20080924155332.GA29041@linux-os.sc.intel.com> <200809301728.02269.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809301728.02269.nickpiggin@yahoo.com.au>
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


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Thursday 25 September 2008 01:53, Venki Pallipadi wrote:
> 
> >  /*
> > + * RED-PEN:  TODO: Add PageReserved() check as well here,
> > + * once we add SetPageReserved() to all the drivers using
> > + * set_memory_* or set_pages_*.
> > + *
> > + * This will help prevent accidentally freeing pages
> > + * before setting the attribute back to WB.
> > + */
> 
> I'd rather we didn't add any more uses of PageReserved without a
> really good reason.
> 
> At this point in time (or at least last time I looked, a year or
> two ago), it isn't a whole lot of work to remove PG_reserved
> completely. If the waters get muddied up again, it could require
> another significant rework to remove it in future...

agreed.

	Ingo
