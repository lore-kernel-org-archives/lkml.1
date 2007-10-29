Return-Path: <linux-kernel-owner+w=401wt.eu-S1752933AbXJ2XCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbXJ2XCq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 19:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbXJ2XCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 19:02:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43983 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863AbXJ2XCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 19:02:38 -0400
Date: Tue, 30 Oct 2007 00:02:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Zachary Amsden <zach@vmware.com>
Cc: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, rusty@rustcorp.com.au,
       jeremy@goop.org, --cc@redhat.com, avi@quramnet.com,
       kvm-devel@lists.sourceforge.net,
       Glauber de Oliveira Costa <glauber@t60.localdomain>,
       Dan Hecht <dhecht@vmware.com>, Garrett Smith <garrett@vmware.com>
Subject: Re: [PATCH] raise tsc clocksource rating
Message-ID: <20071029230213.GA1982@elte.hu>
References: <11936994092607-git-send-email-gcosta@redhat.com> <1193697734.9793.86.camel@bodhitayantram.eng.vmware.com> <20071029224852.GA27547@elte.hu> <1193698505.9793.90.camel@bodhitayantram.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193698505.9793.90.camel@bodhitayantram.eng.vmware.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Zachary Amsden <zach@vmware.com> wrote:

> On Mon, 2007-10-29 at 23:48 +0100, Ingo Molnar wrote:
> > * Zachary Amsden <zach@vmware.com> wrote:
> 
> > if it's inaccurate why are you exposing it to the guest then? Native 
> > only uses the TSC if it's safe and accurate to do so.
> 
> Not every guest support paravirt, but for correctness, all guests 
> require TSC, which must be exposed all the way up to userspace, no 
> matter what the efficiency or accuracy may be.

but if there's a perfect TSC available (there is such hardware) then the 
TSC _is_ the best clocksource. Paravirt now turns it off unconditionally 
in essence.

anyway, that's at most an optimization issue. No strong feelings here, 
and we can certainly delay this patch until this gets all sorted out.

	Ingo
