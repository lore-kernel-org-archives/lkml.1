Return-Path: <linux-kernel-owner+w=401wt.eu-S1760157AbYGRWtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760157AbYGRWtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbYGRWtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:49:24 -0400
Received: from mga14.intel.com ([143.182.124.37]:12431 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884AbYGRWtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:49:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,212,1215414000"; 
   d="scan'208";a="22178497"
Date: Fri, 18 Jul 2008 15:49:23 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Zachary Amsden <zach@vmware.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] x86: APIC: Remove apic_write_around(); use alternatives
Message-ID: <20080718224922.GB4507@linux-os.sc.intel.com>
References: <Pine.LNX.4.55.0807161837080.30858@cliff.in.clinika.pl> <20080718105259.GY6875@elte.hu> <86802c440807180925t6fadfa58r6bf7740f8145482e@mail.gmail.com> <86802c440807181001h4426c197vc474f81497a5b42@mail.gmail.com> <20080718210348.GB24373@elte.hu> <86802c440807181413n7e79e821l90afaae86b322de9@mail.gmail.com> <Pine.LNX.4.55.0807182254270.12125@cliff.in.clinika.pl> <1216420937.30348.30.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216420937.30348.30.camel@bodhitayantram.eng.vmware.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 03:42:17PM -0700, Zachary Amsden wrote:
> On Fri, 2008-07-18 at 15:02 -0700, Maciej W. Rozycki wrote:
> > On Fri, 18 Jul 2008, Yinghai Lu wrote:
> >
> > >   CC      arch/x86/kernel/apic_64.o
> > > arch/x86/kernel/apic_64.c:170: error: unknown field 'write_atomic'
> > > specified in initializer
> > > arch/x86/kernel/apic_64.c:170: error: 'native_apic_mem_write_atomic'
> > > undeclared here (not in a function)
> > > arch/x86/kernel/apic_64.c:209: error: unknown field 'write_atomic'
> > > specified in initializer
> > > arch/x86/kernel/apic_64.c:209: warning: initialization from
> > > incompatible pointer type
> > > make[1]: *** [arch/x86/kernel/apic_64.o] Error 1
> > > make: *** [arch/x86/kernel] Error 2
> >
> >  Just remove the offending initialisers.  They are not needed anymore as
> > the .write method is now used universally including places where
> > .write_atomic was.  I just could not stand watching the thing
> > proliferate...
> 
> Thank you for cleaning this up Yinghai, but this really begs the
> question - is having write_atomic REALLY worthwhile?

And this thread is about,  Maciej's cleanup patch which removed
write_atomic completely :)

Thanks to Maciej who posted this fix. It was on my todo list for
sometime now!

thanks,
suresh
