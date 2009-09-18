Return-Path: <linux-kernel-owner+w=401wt.eu-S1755075AbZIRBES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075AbZIRBES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 21:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbZIRBEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 21:04:16 -0400
Received: from sous-sol.org ([216.99.217.87]:49232 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753600AbZIRBEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 21:04:15 -0400
Date: Thu, 17 Sep 2009 17:58:08 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Alok Kataria <akataria@vmware.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, virtualization@lists.osdl.org
Subject: Re: Paravirtualization on VMware's Platform [VMI].
Message-ID: <20090918005808.GJ26034@sequoia.sous-sol.org>
References: <1253233028.19731.63.camel@ank32.eng.vmware.com> <20090918003412.GI26034@sequoia.sous-sol.org> <4AB2DA0D.8020606@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB2DA0D.8020606@goop.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> On 09/17/09 17:34, Chris Wright wrote:
> >> One of the options that I am contemplating is to drop the code from the
> >> tip tree in this release cycle, and given that this should be a low risk
> >> change we can remove it from Linus's tree later in the merge cycle.
> >>
> >> Let me know your views on this or if you think we should do this some
> >> other way.
> >>     
> > Typically we give time measured in multiple release cycles
> > before deprecating a feature.  This means placing an entry in
> > Documentation/feature-removal-schedule.txt, and potentially
> > adding some noise to warn users they are using a deprecated
> > feature.
> 
> That's true if the feature has some functional effect on users.  But at
> first sight, VMI is really just an optimisation, and a non-VMI-equipped
> kernel would be completely functionally equivalent, right?

True.  I'm all for removing code that's got no planned maintenance and
no place to run ;-)

> On the other hand, there could well be a performance regression which
> could affect users.  However they're taking the explicit step of
> withdrawing support for VMI, so I guess they can just take that in their
> stride.

Yeah.  Different than normal deprecation since it's atop VMware's HV
which is all in their domain.

thanks,
-chris
