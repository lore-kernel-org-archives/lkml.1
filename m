Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbYGMQn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbYGMQn3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 12:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbYGMQnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 12:43:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:63209 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbYGMQnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 12:43:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,354,1212390000"; 
   d="scan'208";a="595673775"
Date: Sun, 13 Jul 2008 09:43:20 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: let 32bit use apic_ops too
Message-ID: <20080713164320.GJ1678@linux-os.sc.intel.com>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807092017.51004.yhlu.kernel@gmail.com> <200807102038.26591.yhlu.kernel@gmail.com> <200807111841.55403.yhlu.kernel@gmail.com> <Pine.LNX.4.55.0807130241390.4128@cliff.in.clinika.pl> <86802c440807121845u3a51b239h95fa46cfb6f7c770@mail.gmail.com> <Pine.LNX.4.55.0807130246560.4128@cliff.in.clinika.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0807130246560.4128@cliff.in.clinika.pl>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2008 at 06:54:53PM -0700, Maciej W. Rozycki wrote:
> On Sat, 12 Jul 2008, Yinghai Lu wrote:
> 
> > >  Etc...  Why are you changing names of these functions?  Are they meant
> > > not to apply to older APIC implementations anymore?
> >
> > because 64bit has that name.
> 
>  Shouldn't it be the other way round then?  Our 32-bit code is the
> original one and supports more APIC variations than the 64-bit one.  So at
> the point of unification 64-bit xAPIC-only functions will become universal
> ones making the naming counter-intuitive: apic_ -> any APIC, xapic_ ->
> xAPIC only.  I think only functions specific to the xAPIC should have the
> xapic_ prefix.

Maciej, Yinghai's current 32bit xapic_* supports both 4-bit apic and xapic.

Yinghai, may be we should name them as apic_mem_* instead of xapic_*
or any better suggestions?

thanks,
suresh
