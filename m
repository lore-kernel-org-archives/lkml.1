Return-Path: <linux-kernel-owner+w=401wt.eu-S933126AbZIDIkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933126AbZIDIkk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 04:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756706AbZIDIkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 04:40:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40099 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701AbZIDIkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 04:40:37 -0400
Subject: Re: CPU scheduler weirdness?
From: Peter Zijlstra <peterz@infradead.org>
To: Marton Balint <cus@fazekas.hu>
Cc: Ingo Molnar <mingo@elte.hu>, Andreas Mohr <andi@lisas.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.0909032350580.20701@cinke.fazekas.hu>
References: <20090813084257.GA761@rhlx01.hs-esslingen.de>
	 <alpine.LNX.2.00.0908131720050.8321@cinke.fazekas.hu>
	 <20090813155812.GA15714@rhlx01.hs-esslingen.de>
	 <alpine.LNX.2.00.0908171758340.2764@cinke.fazekas.hu>
	 <1250665455.7583.326.camel@twins>
	 <alpine.LNX.2.00.0908191353100.19120@cinke.fazekas.hu>
	 <1250683834.7583.360.camel@twins>
	 <alpine.LNX.2.00.0908191428300.20409@cinke.fazekas.hu>
	 <1250707331.7154.1.camel@laptop>
	 <alpine.LNX.2.00.0908192125180.4364@cinke.fazekas.hu>
	 <20090820105645.GA23635@elte.hu>
	 <alpine.LNX.2.00.0908201814270.12548@cinke.fazekas.hu>
	 <alpine.LNX.2.00.0908282240480.32738@cinke.fazekas.hu>
	 <alpine.LNX.2.00.0909032350580.20701@cinke.fazekas.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 04 Sep 2009 10:40:31 +0200
Message-Id: <1252053631.7564.2.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-03 at 23:57 +0200, Marton Balint wrote:
> > sched: fine-tune SD_MC_INIT:
> > 14800984706bf6936bbec5187f736e928be5c218
> >
> > If I add again the removed SD_BALANCE_NEWIDLE to flags, then everything works 
> > as expected. So what would be the correct fix for this bug? Revert the patch? 
> > Or just add SD_BALANCE_NEWIDLE to flags?
> 
> 
> Ingo, Peter, could any of you guys have a look at the commit that caused 
> this bug? Is it OK to revert it? Or a fix somewhere else is necessary? I'm 
> pushing this because I hope that this bug will get fixed in the upcoming 
> stable kernel...

I'm fine with re-adding SD_BALANCE_IDLE and SD_WAKE_IDLE on SMT/MC/CPU
levels.

Ingo?
