Return-Path: <linux-kernel-owner+w=401wt.eu-S1753194AbXJ2Wtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbXJ2Wtb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 18:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbXJ2WtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 18:49:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59687 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785AbXJ2WtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 18:49:18 -0400
Date: Mon, 29 Oct 2007 23:48:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Zachary Amsden <zach@vmware.com>
Cc: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, rusty@rustcorp.com.au,
       jeremy@goop.org, --cc@redhat.com, avi@quramnet.com,
       kvm-devel@lists.sourceforge.net,
       Glauber de Oliveira Costa <glauber@t60.localdomain>,
       Dan Hecht <dhecht@vmware.com>, Garrett Smith <garrett@vmware.com>
Subject: Re: [PATCH] raise tsc clocksource rating
Message-ID: <20071029224852.GA27547@elte.hu>
References: <11936994092607-git-send-email-gcosta@redhat.com> <1193697734.9793.86.camel@bodhitayantram.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193697734.9793.86.camel@bodhitayantram.eng.vmware.com>
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

> On Mon, 2007-10-29 at 20:10 -0300, Glauber de Oliveira Costa wrote:
> > From: Glauber de Oliveira Costa <glauber@t60.localdomain>
> > 
> > tsc is very good time source (when it does not have drifts, does not
> > change it's frequency, i.e. when it works), so it should have its rating
> > raised to a value greater than, or equal 400.
> > 
> > Since it's being a tendency among paravirt clocksources to use values
> > around 400, we should declare tsc as even better: So we use 500.
> 
> Why is the TSC better than a paravirt clocksource?  In our case this 
> is definitely inaccurate.  Paravirt clocksources should be preferred 
> to TSC, and both must be made available in hardware for platforms 
> which do not support paravirt.

if it's inaccurate why are you exposing it to the guest then? Native 
only uses the TSC if it's safe and accurate to do so.

	Ingo
