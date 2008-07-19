Return-Path: <linux-kernel-owner+w=401wt.eu-S1756613AbYGSVu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613AbYGSVu0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 17:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbYGSVuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 17:50:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38767 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960AbYGSVuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 17:50:14 -0400
Date: Sat, 19 Jul 2008 23:49:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Zachary Amsden <zach@vmware.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] x86: APIC: Remove apic_write_around(); use alternatives
Message-ID: <20080719214944.GC836@elte.hu>
References: <86802c440807181001h4426c197vc474f81497a5b42@mail.gmail.com> <20080718210348.GB24373@elte.hu> <86802c440807181413n7e79e821l90afaae86b322de9@mail.gmail.com> <Pine.LNX.4.55.0807182254270.12125@cliff.in.clinika.pl> <1216420937.30348.30.camel@bodhitayantram.eng.vmware.com> <20080718224922.GB4507@linux-os.sc.intel.com> <86802c440807181551l7e6e143dy7cea8ab59f1830ed@mail.gmail.com> <20080718230012.GD4507@linux-os.sc.intel.com> <86802c440807181604y502e7deal98abfeb1ceee769d@mail.gmail.com> <20080718231828.GE4507@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080718231828.GE4507@linux-os.sc.intel.com>
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Fri, Jul 18, 2008 at 04:04:29PM -0700, Yinghai Lu wrote:
> > On Fri, Jul 18, 2008 at 4:00 PM, Suresh Siddha
> > <suresh.b.siddha@intel.com> wrote:
> > > On Fri, Jul 18, 2008 at 03:51:07PM -0700, Yinghai Lu wrote:
> > >> On Fri, Jul 18, 2008 at 3:49 PM, Suresh Siddha
> > >> <suresh.b.siddha@intel.com> wrote:
> > >> > Thanks to Maciej who posted this fix. It was on my todo list for
> > >> > sometime now!
> > >>
> > >> do we rebase tip/x86/x2apic or rework this patch?
> > >
> > > Ingo just did the merge. And I posted a missing piece. So is this enough?
> > 
> > maciej, patch will go first, and x2apic will goes later, so bisect on
> > x2apic will be broken.
> 
> hm, ok. Ingo? should I send the rebased 30 or so patches. or we can 
> move this patch later.

hm, yes, please send the rebased patches - as this stuff has some risks 
so bisectability is important.

	Ingo
