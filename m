Return-Path: <linux-kernel-owner+w=401wt.eu-S1754264AbYAVVx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbYAVVx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 16:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbYAVVxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 16:53:50 -0500
Received: from www.tglx.de ([62.245.132.106]:58142 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbYAVVxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 16:53:49 -0500
Date: Tue, 22 Jan 2008 22:53:18 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de>,
       Jordan Crouse <jordan.crouse@amd.com>, Lars Heete <hel@admin.de>,
       Andres Salomon <dilinger@queued.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] was: Re: 2.6.24-rc8 hangs at mfgpt-timer
In-Reply-To: <20080122211014.GA27870@elte.hu>
Message-ID: <alpine.LFD.1.00.0801222244500.27071@apollo.tec.linutronix.de>
References: <20080116165606.3ebc06a4@ephemeral> <478FCDB6.4010708@i4.informatik.rwth-aachen.de> <4795B14C.7040502@i4.informatik.rwth-aachen.de> <200801221111.21240.hel@admin.de> <4795D120.7070806@i4.informatik.rwth-aachen.de> <20080122192757.GC5241@cosmic.amd.com>
 <47965806.6080903@i4.informatik.rwth-aachen.de> <20080122211014.GA27870@elte.hu>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jan 2008, Ingo Molnar wrote:
> * Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de> wrote:
> 
> > > The attached patch rearranges the code so that the handler is 
> > > installed before we setup the interrupt (so we have somebody to 
> > > listen to the immediate interrupt), and it makes sure that we clear 
> > > the event in the IRQ handler regardless of the state of the timer 
> > > tick.
> > 
> > This patch indeed solves the problem. The board boots fine. Great 
> > work!
> 
> since this driver is new in 2.6.24, perhaps we should apply this fix to 
> v2.6.24?

Yes. It is definitely a safe change and makes otherwise broken systems
work. There is no impact to anything else than the GEODEs.

Linus,

if you agree, please pull the fix from:

 ssh://master.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

Thanks,

	tglx
