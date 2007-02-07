Return-Path: <linux-kernel-owner+w=401wt.eu-S965630AbXBGBMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965630AbXBGBMn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 20:12:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965632AbXBGBMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 20:12:43 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:15816 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965630AbXBGBMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 20:12:43 -0500
Subject: Re: 2.6.20-rc6-mm3
From: Daniel Walker <dwalker@mvista.com>
Reply-To: dwalker@mvista.com
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1170804989.3785.58.camel@chaos>
References: <20070206205231.GA25430@elte.hu>
	 <1170795378.3455.31.camel@dwalker1> <20070206210959.GC25430@elte.hu>
	 <1170796999.3455.43.camel@dwalker1> <20070206214131.GA1176@elte.hu>
	 <1170798879.3455.58.camel@dwalker1> <20070206220855.GB5109@elte.hu>
	 <1170801742.3455.87.camel@dwalker1> <20070206225650.GA14853@elte.hu>
	 <1170803070.3455.93.camel@dwalker1>  <20070206231421.GA18654@elte.hu>
	 <1170804177.3455.109.camel@dwalker1>  <1170804989.3785.58.camel@chaos>
Content-Type: text/plain
Date: Tue, 06 Feb 2007 17:12:41 -0800
Message-Id: <1170810761.3455.147.camel@dwalker1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-07 at 00:36 +0100, Thomas Gleixner wrote:

> There are no other clock event devices in a PC system at the moment
> and /proc/interrupt does not care, whether the interrupt was setup for a
> clock event device or something else. It displays the name which is
> given in the irqaction struct and does not care what it means. I did not
> change the name in the IRQ#0 setup, so it still displays "timer" (which
> can either be PIT or HPET), but this is something the interrupt layer
> does not know and does not care about.

So your saying the "timer" entry in /proc/interrupts can be either the
HPET timer, the PIT timer? Mine says "IO-APIC-edge" which does that map
to? It's going though the io-apic but it's still the pit ?

Daniel

