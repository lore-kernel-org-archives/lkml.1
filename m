Return-Path: <linux-kernel-owner+w=401wt.eu-S934918AbZLGQGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934918AbZLGQGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 11:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934681AbZLGQGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 11:06:17 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:35579 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934560AbZLGQGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 11:06:15 -0500
Date: Mon, 7 Dec 2009 10:06:09 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Ioannis Kyriakopoulos <johnkyr83@hotmail.com>
cc: linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: timer interrupt stucks using tickless kernel
In-Reply-To: <SNT111-DS1957B574BA05A48FEDBFF0A7900@phx.gbl>
Message-ID: <alpine.DEB.2.00.0912070959310.1208@router.home>
References: <SNT111-DS1957B574BA05A48FEDBFF0A7900@phx.gbl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Dec 2009, Ioannis Kyriakopoulos wrote:

> I have configured my kernel (2.6.31.6) so that I get periodic ticks from
> the timer interrupt (i.e. tickless is not configured) with a rate determined
> by the HZ value. I've also checked the "high resolution timer support"
> and also SMP support. The posblem is that the timer is getting incremented
> very slowly (way slower than the HZ value), just like it would be if the
> kernel was tickless. Is there an explanation for that? How can I get
> periodic
> timer ticks?

This is what platform? Embedded? Timer is referring to the system time
running slow? kernel boot log would be useful.

> AFAI understand, the HPET timer is used through the IO-APIC controller to
> trigger the processors (N.B. if the "High Resolution Timer Support" option
> wasn't checked, the timer used would  be PIT, right?) and each processor's
> LAPIC timer is used for time keeping. Please correct me if I am wrong.
>
> Another question is how the LAPIC timner's rate is determined? In my case,
> it seams that an interurpt by LAPIC timer is generated very appoximately
> 0.25 sec (that is HZ which is 1000 * 4) but I can't understand why.

You could have 4 processors that each need a timer interrupt at
1000 HZ?

