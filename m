Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab0CBPZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 10:25:21 -0500
Received: from mtagate3.de.ibm.com ([195.212.17.163]:44494 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab0CBPZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 10:25:19 -0500
Date: Tue, 2 Mar 2010 16:25:14 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>
Cc: Aaro Koskinen <aaro.koskinen@nokia.com>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Rob van der Heij <rvdheij@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       john stultz <johnstul@us.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, robert.richter@amd.com
Subject: Re: [patch 0/2] NOHZ vs. profile/oprofile v2
Message-ID: <20100302162514.2548e185@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <alpine.LFD.2.00.1003021605570.4245@localhost.localdomain>
References: <20090603152223.083010123@de.ibm.com>
	<alpine.LFD.2.00.0906092252150.3351@localhost.localdomain>
	<20090622162631.4b4dcee4@skybase>
	<20090622144110.GA9771@elte.hu>
	<20090622165936.0bb776e1@skybase>
	<20090622150553.GA14363@elte.hu>
	<20090622171834.0df64aea@skybase>
	<20090622152937.GA17512@elte.hu>
	<20090622173611.3b583c95@skybase>
	<20090622154030.GA19076@elte.hu>
	<20090624185100.6ca7e82a@skybase>
	<4B8D1942.8060405@nokia.com>
	<20100302160110.5fd14f5f@mschwide.boeblingen.de.ibm.com>
	<alpine.LFD.2.00.1003021605570.4245@localhost.localdomain>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Mar 2010 16:08:09 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Tue, 2 Mar 2010, Martin Schwidefsky wrote:
> 
> > On Tue, 02 Mar 2010 15:57:22 +0200
> > Aaro Koskinen <aaro.koskinen@nokia.com> wrote:
> > 
> > > Hi,
> > > 
> > > Martin Schwidefsky wrote:
> > > > First version of the hrtimer patch for oprofile. I did not add the
> > > > sysctl yet, if the sysctl is added in oprofile_timer_init it would not
> > > > be available if some better profiling source is available. If it is
> > > > added unconditionally it would only have an effect if the timer
> > > > fallback is used. Both cases are not exactly nice for a user space
> > > > interface.
> > > 
> > > I wonder what happened to this patch? Some platforms would need
> > > this fix (i.e. the timer mode has to be used due to HW issues).
> > 
> > After SH removed their oprofile hook there is nothing left that would
> > prevent us from converting oprofile to hrtimer. Just a matter of
> > reminding me and have me try again ;-)
> > 
> > Patch against current git. Ingo, Thomas: one for the timer tree I guess.
> 
> No objections from my side, but shouldn't that go via Robert ?

Agreed, this should be handled by the oprofile maintainer.
Robert, could you take care of the patch?

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

