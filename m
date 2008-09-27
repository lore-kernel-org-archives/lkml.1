Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbYI0R7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbYI0R7j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 13:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbYI0R7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 13:59:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35023 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145AbYI0R7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 13:59:30 -0400
Date: Sat, 27 Sep 2008 19:59:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [patch 1/2] x86: track memtype for RAM in page struct - v3
Message-ID: <20080927175911.GB1108@elte.hu>
References: <20080913000003.732756000@linux-os.sc.intel.com> <20080913000051.819383000@linux-os.sc.intel.com> <48CBF25B.5030107@goop.org> <20080914132952.GC554@elte.hu> <48CD1D1E.1050906@goop.org> <20080914142213.GA28162@elte.hu> <20080923214558.GA13357@linux-os.sc.intel.com> <48D966AE.1040008@linux-foundation.org> <20080924155332.GA29041@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080924155332.GA29041@linux-os.sc.intel.com>
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


* Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:

> On Tue, Sep 23, 2008 at 02:59:10PM -0700, Christoph Lameter wrote:
> > I'd suggest to avoid the open coding of page flag handling using set bit etc.
> > 
> > It may be best to slowly migrate the arch specific definitions into
> > page-flags.h. Otherwise we wont have a central authority on page flags.
> > 
> 
> OK. Below is the updated patch that does not use set/clear directly on page
> flag.
> 
> x86: track memtype for RAM in page struct
> 
> From: Suresh Siddha <suresh.b.siddha@intel.com>
> Subject: x86: track memtype for RAM in page struct

applied to tip/x86/pat, thanks! Nice patch.

	Ingo
