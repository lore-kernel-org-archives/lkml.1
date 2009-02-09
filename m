Return-Path: <linux-kernel-owner+w=401wt.eu-S1755162AbZBIMLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbZBIMLL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 07:11:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbZBIMK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 07:10:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55344 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295AbZBIMKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 07:10:55 -0500
Date: Mon, 9 Feb 2009 13:10:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alok Kataria <akataria@vmware.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Zach Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Rohit Jain <rjain@vmware.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PARAVIRT/x86] BUGFIX: Put a missing paravirt_release_pmd in
	pgd_dtor
Message-ID: <20090209121045.GF17782@elte.hu>
References: <1233885731.29693.26.camel@alok-dev1> <498BA0CA.2040603@goop.org> <1233901043.8943.6.camel@alok-dev1> <498BDE1D.8030101@goop.org> <20090206145324.GF18368@elte.hu> <498C6CC9.5050302@goop.org> <1233944975.15269.14.camel@alok-dev1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233944975.15269.14.camel@alok-dev1>
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


* Alok Kataria <akataria@vmware.com> wrote:

> On Fri, 2009-02-06 at 09:00 -0800, Jeremy Fitzhardinge wrote:
> > >   
> > 
> > Yeah.  Though:
> > >  /*
> > > + * We hack the pgd_free hook for releasing the pgd page.
> > >   
> > Its hardly a hack to use a hook for exactly its intended purpose...
> 
> Ok Ingo, below is the patch with a better comment. Please apply this.

Applied to tip:x86/urgent, thanks guys!

	Ingo
