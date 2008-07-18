Return-Path: <linux-kernel-owner+w=401wt.eu-S1760486AbYGRXSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760486AbYGRXSi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 19:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755081AbYGRXSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 19:18:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:54484 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394AbYGRXSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 19:18:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,212,1215414000"; 
   d="scan'208";a="316590348"
Date: Fri, 18 Jul 2008 16:18:28 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Zachary Amsden <zach@vmware.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] x86: APIC: Remove apic_write_around(); use alternatives
Message-ID: <20080718231828.GE4507@linux-os.sc.intel.com>
References: <86802c440807180925t6fadfa58r6bf7740f8145482e@mail.gmail.com> <86802c440807181001h4426c197vc474f81497a5b42@mail.gmail.com> <20080718210348.GB24373@elte.hu> <86802c440807181413n7e79e821l90afaae86b322de9@mail.gmail.com> <Pine.LNX.4.55.0807182254270.12125@cliff.in.clinika.pl> <1216420937.30348.30.camel@bodhitayantram.eng.vmware.com> <20080718224922.GB4507@linux-os.sc.intel.com> <86802c440807181551l7e6e143dy7cea8ab59f1830ed@mail.gmail.com> <20080718230012.GD4507@linux-os.sc.intel.com> <86802c440807181604y502e7deal98abfeb1ceee769d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807181604y502e7deal98abfeb1ceee769d@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 04:04:29PM -0700, Yinghai Lu wrote:
> On Fri, Jul 18, 2008 at 4:00 PM, Suresh Siddha
> <suresh.b.siddha@intel.com> wrote:
> > On Fri, Jul 18, 2008 at 03:51:07PM -0700, Yinghai Lu wrote:
> >> On Fri, Jul 18, 2008 at 3:49 PM, Suresh Siddha
> >> <suresh.b.siddha@intel.com> wrote:
> >> > Thanks to Maciej who posted this fix. It was on my todo list for
> >> > sometime now!
> >>
> >> do we rebase tip/x86/x2apic or rework this patch?
> >
> > Ingo just did the merge. And I posted a missing piece. So is this enough?
> 
> maciej, patch will go first, and x2apic will goes later, so bisect on
> x2apic will be broken.

hm, ok. Ingo? should I send the rebased 30 or so patches. or we can move this
patch later.

thanks,
suresh
