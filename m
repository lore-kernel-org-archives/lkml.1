Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbZA3TjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbZA3TjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 14:39:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbZA3Ti6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 14:38:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40545 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031AbZA3Ti5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 14:38:57 -0500
Date: Fri, 30 Jan 2009 20:38:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] voyager: fix up for moving the generic smp call func
	to pointers
Message-ID: <20090130193849.GC32705@elte.hu>
References: <1233340524.3248.45.camel@localhost.localdomain> <20090130185411.GA9984@elte.hu> <1233341963.3248.48.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233341963.3248.48.camel@localhost.localdomain>
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


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Fri, 2009-01-30 at 19:54 +0100, Ingo Molnar wrote:
> > James,
> > 
> > * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > 
> > > commit e7986739a76cde5079da08809d8bbc6878387ae0
> > > Author: Mike Travis <travis@sgi.com>
> > > Date:   Tue Dec 16 17:33:52 2008 -0800
> > > 
> > >     x86 smp: modify send_IPI_mask interface to accept cpumask_t pointers
> > > 
> > > Changed all the IPI ops to take pointers, but didn't update voyager,
> > > which is now broken.  Make the changes in voyager as well.
> > 
> > Note: earlier this week i've rearchitectured the x86 subarchitecture and 
> > APIC code - so there's a whole lot more to be done on the Voyager side 
> > than just the cpumask conversion.
> 
> Not for 2.6.29 there isn't.
> 
> > The x86/Voyager subarch is not fully ported yet (i cleaned up its Kconfig 
> > impact already) and hence it is disabled for the time being. It ought to 
> > be relatively straightforward to port it to the new code - if you are 
> > interested in doing that.
> > 
> > You can find the latest code in tip/master at:
> > 
> >    http://people.redhat.com/mingo/tip.git/README
> > 
> > it's tentatively aimed for v2.6.30.
> 
> Right, and I'll fix the rest for 2.6.30. [...]

ok.

> [...] However, this patch is needed now to get 2.6.29-rc3 to boot.

and there's also the other ones. We can put them in now that we've got the 
new subarch code. Could you send a pull request with all the voyager fixes 
collected into one tree?

	Ingo
