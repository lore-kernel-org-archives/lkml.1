Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbYANUMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbYANUMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 15:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751218AbYANUMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 15:12:09 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42560 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbYANUMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 15:12:08 -0500
Date: Mon, 14 Jan 2008 21:15:05 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: unify pagetable accessors patch causes double fault III
Message-ID: <20080114201505.GC19102@one.firstfloor.org>
References: <20080114094814.GA28300@basil.nowhere.org> <20080114125638.GA9510@basil.nowhere.org> <20080114130620.GA14057@elte.hu> <20080114135811.GA16190@one.firstfloor.org> <478B9183.3020101@goop.org> <20080114165635.GK15542@elte.hu> <20080114170856.GA18412@one.firstfloor.org> <20080114171838.GA18662@one.firstfloor.org> <20080114190004.GB26540@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114190004.GB26540@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 08:00:04PM +0100, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > BTW there seems to be some other instability that hits even on 64bit. 
> > Since I updated my workstation to a recent git-x86 based kernel 
> > (admittedly with my patches too) I had at least one hard hang already.
> > 
> > Previously it ran an older -rc5 based kernel without git-x86 also with 
> > most of my patches and was stable for >23 days until a KVM oops 
> > required a reboot.
> > 
> > It unfortunately was not set up to receive console at this point and 
> > it hung in X, but I'm watching it now.
> 
> hm. Did the hanging kernel have the i387 regset fix from Roland already? 
> That bug indeed manifested itself as rare desktop hangs.

Which patch was that exactly? I don't see an obvious candidate. It was
git-x86 of friday or so. I still got the whole patch, but not the change
set tip because I've updated since again.

The hang happened while I started a large java program (groupwise) and
the machine was dead as in no pings anymore.

KVM might have been running in the background but only idling (I earlier
managed to oops the 2.6.24-rc* KVM, but only with a special guest 
which was not active at that time) 

-Andi
