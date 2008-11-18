Return-Path: <linux-kernel-owner+w=401wt.eu-S1752361AbYKRD0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361AbYKRD0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 22:26:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751760AbYKRD0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 22:26:05 -0500
Received: from casper.infradead.org ([85.118.1.10]:53740 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbYKRD0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 22:26:04 -0500
Date: Mon, 17 Nov 2008 19:26:29 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Support always running TSC on Intel CPUs
Message-ID: <20081117192629.664fc364@infradead.org>
In-Reply-To: <4922154E.4050108@zytor.com>
References: <20081118001137.GA12350@linux-os.sc.intel.com>
	<492208BE.2000001@zytor.com>
	<7E82351C108FA840AB1866AC776AEC464291B456@orsmsx505.amr.corp.intel.com>
	<492209C8.7040602@zytor.com>
	<20081118004918.GA19416@linux-os.sc.intel.com>
	<492211C5.7090302@zytor.com>
	<20081118010528.GA22044@linux-os.sc.intel.com>
	<4922154E.4050108@zytor.com>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2008 17:07:26 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> Venki Pallipadi wrote:
> >>>
> >> I was under the impression that C2 was invoked by the chipset on a
> >> thermal condition, at least on older (P3-era) processors.  Is that
> >> no longer true?  If what you say is above (HLT and MWAIT only),
> >> then *was* it ever true?
> > 
> > I should also add io port based C-state to HLT and MWAIT. But, that
> > again is OS initiated.
> > 
> > I don't know of C2 invocation in thermal condition. Thermal
> > condition, all CPUs that I know of (P3 and beyond), use either
> > clock modulation or frequency changes. And on some such CPUs, where
> > TSC runs at constant freq during such modulation/freq change, we
> > set CONSTANT_TSC bit based on model number check. So, on CPUs
> > earlier than those, we cannot use TSC or we have to scale TSC based
> > on freq. This patch shouldn't have any impact for those CPUs.
> > 
> 
> I believe there are CPUs -- again, in the P3-era range at least --
> which invoke C2 from the chipset on thermal conditions (and basically
> PWM the CPU.)  I'd like to get that clarified so we don't trip up on
> that.

p3-era cpus didn't stop tsc in c2 afaik.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
