Return-Path: <linux-kernel-owner+w=401wt.eu-S1752626AbXCHUHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbXCHUHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 15:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbXCHUHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 15:07:55 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:56468 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626AbXCHUHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 15:07:54 -0500
Date: Thu, 8 Mar 2007 11:47:40 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Daniel Arai <arai@vmware.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       akpm@linux-foundation.org, john stultz <johnstul@us.ibm.com>,
       tglx@linutronix.de, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
Message-ID: <20070308194740.GJ10574@sequoia.sous-sol.org>
References: <45EF0CF5.5090305@goop.org> <45EF175D.6030609@vmware.com> <1173302503.24738.795.camel@localhost.localdomain> <45EF372E.7030600@goop.org> <1173308717.24738.898.camel@localhost.localdomain> <45EF49E9.7040509@vmware.com> <1173313373.24738.937.camel@localhost.localdomain> <45EF6077.9090302@vmware.com> <20070308182456.GH19575@sequoia.sous-sol.org> <45F06720.8080901@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F06720.8080901@goop.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> Chris Wright wrote:
> > * Daniel Arai (arai@vmware.com) wrote:
> >   
> >> There's no good way to override __send_IPI_shortcut.  I suppose we could add 
> >> paravirt ops for __send_IPI_shortcut and every other op that touches the APIC. 
> >>     
> >
> > While that's basically what we did in Xen, it would make more sense to
> > build it into genapic which would give us one common abstraction to base
> > from.  We should avoid adding pv_ops when existing infrastructure exists.
> 
> I was looking at cutting in at a much higher level.  The interface in
> <linux/smp.h> is a good match for Xen, so I was going to investigate
> making pv_ops at that level and see how it falls out.

I agree with that, but I think that's esp. for things like create and launch
new vcpu.  The IPI bit I'm not as clear on, nor running this all on native
as well.

thanks,
-chris
