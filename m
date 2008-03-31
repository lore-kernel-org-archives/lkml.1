Return-Path: <linux-kernel-owner+w=401wt.eu-S1756788AbYCaCXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788AbYCaCXj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 22:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756437AbYCaCX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 22:23:26 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60759 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756341AbYCaCX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 22:23:26 -0400
Date: Sun, 30 Mar 2008 21:23:23 -0500
From: Jack Steiner <steiner@sgi.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <ak@suse.de>, mingo@elte.hu, tglx@linutronix.de,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] x86_64: Support for new UV apic
Message-ID: <20080331022323.GD20619@sgi.com>
References: <20080328191216.GA16455@sgi.com> <86802c440803301622j2874ca56t51b52a54920a233b@mail.gmail.com> <20080331020613.GA20619@sgi.com> <86802c440803301913n1cd4fe88v2374a8ba835153e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440803301913n1cd4fe88v2374a8ba835153e@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2008 at 07:13:42PM -0700, Yinghai Lu wrote:
> On Sun, Mar 30, 2008 at 7:06 PM, Jack Steiner <steiner@sgi.com> wrote:
> > > so this is "the new one of Friday"?
> >
> >  Yes, and it has the same bug although it is located
> >  in a slightly different place.
> >
> >  A few minutes ago, I posted a patch to delete the extra lines.
> >
> >
> >
> >  > Did you test it on non UV_X2APIC box?
> >
> >  The code is clearly wrong.  I booted on an 8p AMD box and
> >  had no problems. Apparently the kernel (at least basic booting) is
> >  not too sensitive to incorrect apicids being returned. Most
> >  critical-to-boot code must use apicids from the ACPI tables.
> >  However, the bug does affect numa node assignment. And probably
> >  other places, too.
> 
> please consider one global get_apic_id() and bad_apicid to replace
> GET_APIC_ID and BAD_APICID at this point.

I think that makes sense.

The x2apic patch that should be posted in the near future also makes
significant changes in this area.  Once that patch is posted, I'll
make the simplifications.

Ok???

--- jack
