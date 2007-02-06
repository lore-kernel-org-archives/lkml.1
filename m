Return-Path: <linux-kernel-owner+w=401wt.eu-S965589AbXBFXfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965589AbXBFXfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965581AbXBFXfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:35:30 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:56153 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965589AbXBFXf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:35:29 -0500
Subject: Re: 2.6.20-rc6-mm3
From: Daniel Walker <dwalker@mvista.com>
Reply-To: dwalker@mvista.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070206232828.GA21969@elte.hu>
References: <20070206210959.GC25430@elte.hu>
	 <1170796999.3455.43.camel@dwalker1> <20070206214131.GA1176@elte.hu>
	 <1170798879.3455.58.camel@dwalker1> <20070206220855.GB5109@elte.hu>
	 <1170801742.3455.87.camel@dwalker1> <20070206225650.GA14853@elte.hu>
	 <1170803070.3455.93.camel@dwalker1> <20070206231421.GA18654@elte.hu>
	 <1170804177.3455.109.camel@dwalker1>  <20070206232828.GA21969@elte.hu>
Content-Type: text/plain
Date: Tue, 06 Feb 2007 15:35:03 -0800
Message-Id: <1170804903.3455.121.camel@dwalker1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-07 at 00:28 +0100, Ingo Molnar wrote:

> actually, i quoted what you said:
> 
> | If we change the current "timer" entry to be listed as "lapic-timer" 
> | and not "IO-APIC-edge" (or one of the other names) and replace it with 
> | the count from LOC
> 
> this is a pretty clear sentence, i dont think i misunderstood anything 
> about it. If i did, please point it out specifically.

Geez , man I've corrected this statement already .. Why don't you quote
the corrections. Your not listening cause your ignoring everything I
said after this, and accepting only my first statement and rejecting
everything else.. Like you want this to descend into a melee .

Last and final correction. I'm saying drop the timer entry, which means
drop the call to request_irq() for irq0 . Add lines for lapic-timer
which take the place of LOC..

Daniel

