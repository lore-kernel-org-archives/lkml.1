Return-Path: <linux-kernel-owner+w=401wt.eu-S1753326AbZIWTNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbZIWTNg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 15:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbZIWTNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 15:13:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56886 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343AbZIWTNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 15:13:35 -0400
Date: Wed, 23 Sep 2009 21:13:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@redhat.com>, the arch/x86 maintainers <x86@kernel.org>,
       Stable Kernel <stable@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL] xen: Check NX state before setting up GDT mapping
Message-ID: <20090923191315.GA14437@elte.hu>
References: <4AB7EC1D.5010102@goop.org> <20090923123616.GC19385@elte.hu> <4ABA7119.6000307@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ABA7119.6000307@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> On 09/23/09 05:36, Ingo Molnar wrote:
> >> +#ifdef CONFIG_X86_64
> >> +	/* Work out if we support NX */
> >> +	check_efer();
> >> +#endif
> >> +
> >>     
> > btw., this #ifdef could sure be eliminated, right?
> >   
> 
> check_efer() is only defined on x86-64 and all its existing callsites 
> have a similar #ifdef.

Yes, a familar pattern that prompted my comment.

> [...]  NX setup is an area which could do with a bit of hitting with 
> the unification stick.

Yes.

	Ingo
