Return-Path: <linux-kernel-owner+w=401wt.eu-S1755340AbYJUSLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbYJUSLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 14:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755189AbYJUSLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 14:11:09 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:25864 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163AbYJUSLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 14:11:06 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC patch 15/15] LTTng timestamp x86
Date: Tue, 21 Oct 2008 12:10:58 -0600
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Luck, Tony" <tony.luck@intel.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>
References: <20081016232729.699004293@polymtl.ca> <alpine.LFD.2.00.0810201451190.3287@nehalem.linux-foundation.org> <48FD0633.70604@zytor.com>
In-Reply-To: <48FD0633.70604@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810211211.00332.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 October 2008 04:29:07 pm H. Peter Anvin wrote:
> Linus Torvalds wrote:
> > 
> > But it's not going to solve the "hey, I have 512 CPU's, they are all on 
> > different boards, and no, they are _not_ synchronized to one global 
> > clock!".
> > 
> > That's why I'd suggest making _purely_ local time, and then aiming for 
> > something NTP-like. But maybe there are better solutions out there.
> 
> At the same time, it would definitely be nice to encourage vendors of 
> large SMP systems to provide a common root crystal (frequency standard) 
> for a single SMP domain.  Preferrably a really good one, TCXO or better.

A single root crystal is nice for us software guys.  But it often
also turns into a single point of failure, which the hardware guys
are always trying to eliminate.  So I think multiple crystals are
inevitable for the really large machines.

Bjorn
