Return-Path: <linux-kernel-owner+w=401wt.eu-S1757848AbXL3O4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848AbXL3O4K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 09:56:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757725AbXL3Ozz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 09:55:55 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:40854 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757723AbXL3Ozx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 09:55:53 -0500
Date: Sun, 30 Dec 2007 15:55:46 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 7/38] arch/x86/ia32: Use time_before, time_before_eq,
 etc.
In-Reply-To: <20071230133335.GA21106@elte.hu>
Message-ID: <Pine.LNX.4.64.0712301554430.8187@ask.diku.dk>
References: <Pine.LNX.4.64.0712241522410.23999@ask.diku.dk>
 <20071224153152.GA21971@one.firstfloor.org> <Pine.LNX.4.64.0712241657080.23999@ask.diku.dk>
 <20071230133335.GA21106@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Dec 2007, Ingo Molnar wrote:

> 
> * Julia Lawall <julia@diku.dk> wrote:
> 
> > On Mon, 24 Dec 2007, Andi Kleen wrote:
> > 
> > > On Mon, Dec 24, 2007 at 03:23:19PM +0100, Julia Lawall wrote:
> > > > From: Julia Lawall <julia@diku.dk>
> > > > 
> > > > The functions time_before, time_before_eq, time_after, and time_after_eq
> > > > are more robust for comparing jiffies against other values.
> > > 
> > > The old code was actually correct I think, but the change is ok for me.
> > 
> > Please ignore the patch.  All of my before_eq and after_eq's are 
> > backwards due to parsing <= as >= and vice versa.  I will try again.
> 
> your x86 patches (#7, #8 and #9) do not include any *_eq() comparisons 
> and they all seem to be correct. So picked those three up into x86.git - 
> let me know if there's any breakage in them that i missed.

Only #7 is ok.  The other two have #include <jiffies.h> in the wrong 
place.  I will send new versions of #8 and #9 shortly.

julia

