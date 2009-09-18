Return-Path: <linux-kernel-owner+w=401wt.eu-S1752880AbZIRBnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbZIRBnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 21:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbZIRBnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 21:43:08 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:46349 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751165AbZIRBnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 21:43:07 -0400
Subject: Re: Paravirtualization on VMware's Platform [VMI].
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Chris Wright <chrisw@sous-sol.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
In-Reply-To: <20090918005808.GJ26034@sequoia.sous-sol.org>
References: <1253233028.19731.63.camel@ank32.eng.vmware.com>
	 <20090918003412.GI26034@sequoia.sous-sol.org> <4AB2DA0D.8020606@goop.org>
	 <20090918005808.GJ26034@sequoia.sous-sol.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Thu, 17 Sep 2009 18:43:10 -0700
Message-Id: <1253238190.19731.75.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2009-09-17 at 17:58 -0700, Chris Wright wrote:
> * Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> > On 09/17/09 17:34, Chris Wright wrote:
> > >> One of the options that I am contemplating is to drop the code from the
> > >> tip tree in this release cycle, and given that this should be a low risk
> > >> change we can remove it from Linus's tree later in the merge cycle.
> > >>
> > >> Let me know your views on this or if you think we should do this some
> > >> other way.
> > >>     
> > > Typically we give time measured in multiple release cycles
> > > before deprecating a feature.  This means placing an entry in
> > > Documentation/feature-removal-schedule.txt, and potentially
> > > adding some noise to warn users they are using a deprecated
> > > feature.
> > 
> > That's true if the feature has some functional effect on users.  But at
> > first sight, VMI is really just an optimisation, and a non-VMI-equipped
> > kernel would be completely functionally equivalent, right?
> 
> True.  I'm all for removing code that's got no planned maintenance and
> no place to run ;-)

That's correct, Jeremy put it as well as I could, VMI was always a
optimization, and we expect that new HW features bridge that performance
gap too. So a generic kernel will run just as well on VMware's platform.

Having said that, I would like to clarify that existing products which
support VMI will still carry on supporting it for the current customer
base. Its only the new products which will stop supporting this feature.

> 
> > On the other hand, there could well be a performance regression which
> > could affect users.  However they're taking the explicit step of
> > withdrawing support for VMI, so I guess they can just take that in their
> > stride.
> 
> Yeah.  Different than normal deprecation since it's atop VMware's HV
> which is all in their domain.

Yep that's true. 

Thanks,
Alok


