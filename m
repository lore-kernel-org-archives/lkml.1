Return-Path: <linux-kernel-owner+w=401wt.eu-S1753829AbYAVVuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbYAVVuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 16:50:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbYAVVuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 16:50:35 -0500
Received: from 1wt.eu ([62.212.114.60]:1520 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbYAVVuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 16:50:35 -0500
Date: Tue, 22 Jan 2008 22:20:59 +0100
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de>,
       Jordan Crouse <jordan.crouse@amd.com>, Lars Heete <hel@admin.de>,
       Andres Salomon <dilinger@queued.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.24-rc8 hangs at mfgpt-timer
Message-ID: <20080122212058.GI8953@1wt.eu>
References: <20080116165606.3ebc06a4@ephemeral> <478FCDB6.4010708@i4.informatik.rwth-aachen.de> <4795B14C.7040502@i4.informatik.rwth-aachen.de> <200801221111.21240.hel@admin.de> <4795D120.7070806@i4.informatik.rwth-aachen.de> <20080122192757.GC5241@cosmic.amd.com> <47965806.6080903@i4.informatik.rwth-aachen.de> <20080122211014.GA27870@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080122211014.GA27870@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2008 at 10:10:14PM +0100, Ingo Molnar wrote:
> 
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

Yes, I do think so. You can add me too to the "Tested-by" lines if you want.

Willy

