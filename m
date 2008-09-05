Return-Path: <linux-kernel-owner+w=401wt.eu-S1754867AbYIEQEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbYIEQEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 12:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929AbYIEQEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 12:04:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58044 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875AbYIEQEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 12:04:33 -0400
Date: Fri, 5 Sep 2008 18:04:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [patch 1/2] x2apic: fix reserved APIC register accesses in
	print_local_APIC()
Message-ID: <20080905160414.GL10292@elte.hu>
References: <20080902234759.554038000@linux-os.sc.intel.com> <Pine.LNX.4.55.0809030625520.23174@cliff.in.clinika.pl> <20080903184552.GE14481@linux-os.sc.intel.com> <Pine.LNX.4.55.0809032145020.23174@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0809032145020.23174@cliff.in.clinika.pl>
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


* Maciej W. Rozycki <macro@linux-mips.org> wrote:

> On Wed, 3 Sep 2008, Suresh Siddha wrote:
> 
> > from SDV Vol 3a Section 17.27.1
> > 
> >   The remote read delivery mode provided in the 82489DX and local APIC for
> >   Pentium processors is not supported in the local APIC in the Pentium 4, Intel
> >   Xeon, and P6 family processors.
> > 
> > It looks like it is not supported (officially atleast) even in APIC bus
> > architectures. Only the Pentium integrated APIC seems to be the exception.
> 
>  Yeah, trust documentation and see where you'll get... ;)

hm, is the remote read debug output, now that it's not present in CPUs 
made in the past 5 years or so, really that important?

	Ingo
