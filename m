Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060AbYBDOpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbYBDOpj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 09:45:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751744AbYBDOpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 09:45:31 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47743 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbYBDOpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 09:45:30 -0500
Subject: Re: 2.6.24-git4+ regression
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080204143622.GC4329@ics.muni.cz>
References: <20080130135609.GA5100@ics.muni.cz>
	 <20080131102919.GC27157@elte.hu> <20080204111747.GB4450@ics.muni.cz>
	 <1202124997.32654.78.camel@lappy>  <20080204143622.GC4329@ics.muni.cz>
Content-Type: text/plain
Date: Mon, 04 Feb 2008 15:45:10 +0100
Message-Id: <1202136310.6890.0.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-04 at 15:36 +0100, Lukas Hejtmanek wrote:
> On Mon, Feb 04, 2008 at 12:36:36PM +0100, Peter Zijlstra wrote:
> > I can't reproduce this with a pure cpu load. I started 10 
> >   while :; do :; done &
> > instances and aside from slowing down, nothing bad happened.
> 
> yes, while true; do true; does nothing wrong. But running make -j2 in kernel
> sources or mesa sources is catastrophic.
>  
> > May I suggest you try latency top to see if there is something in your
> > build scenario that generates horrible latencies (some IO path or
> > whatnot).
> 
> see my previous mail to Ingo (you were Cc.), latency top says that Xorg and
> gnome-terminal suffers 300+ms latency in scheduler: waiting for cpu.

what happens when you turn CONFIG_FAIR_GROUP_SCHED off?

