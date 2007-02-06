Return-Path: <linux-kernel-owner+w=401wt.eu-S1030311AbXBFXEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030311AbXBFXEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:04:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030504AbXBFXEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:04:33 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:45256 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030311AbXBFXEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:04:32 -0500
Subject: Re: 2.6.20-rc6-mm3
From: Daniel Walker <dwalker@mvista.com>
Reply-To: dwalker@mvista.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070206225650.GA14853@elte.hu>
References: <1170793206.3785.16.camel@chaos>
	 <1170794437.3455.20.camel@dwalker1> <20070206205231.GA25430@elte.hu>
	 <1170795378.3455.31.camel@dwalker1> <20070206210959.GC25430@elte.hu>
	 <1170796999.3455.43.camel@dwalker1> <20070206214131.GA1176@elte.hu>
	 <1170798879.3455.58.camel@dwalker1> <20070206220855.GB5109@elte.hu>
	 <1170801742.3455.87.camel@dwalker1>  <20070206225650.GA14853@elte.hu>
Content-Type: text/plain
Date: Tue, 06 Feb 2007 15:04:30 -0800
Message-Id: <1170803070.3455.93.camel@dwalker1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-06 at 23:56 +0100, Ingo Molnar wrote:

> changing the current 'timer' entry (which is line 2 of /proc/interrupts) 
> to be 'listed as lapic-timer' and to 'replace it with the count from 
> LOC' is faking a count in a line where nothing like that should be.

This point is getting irrelevant ..

> the kernel simply displays reality: IRQ#0 isnt increasing because it's 
> not used, and LOC (local apic timers) is increasing.

What about the statistics for the other interrupts in the system ? It
clearly doesn't list all interrupts in the system .

Daniel

