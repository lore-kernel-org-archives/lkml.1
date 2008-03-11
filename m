Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbYCKRcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbYCKRcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 13:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbYCKRcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 13:32:01 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:52838 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214AbYCKRcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 13:32:00 -0400
Date: Tue, 11 Mar 2008 18:31:49 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-pm@lists.linux-foundation.org,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@codemonkey.org.uk>,
       Alan Stern <stern@rowland.harvard.edu>, Adam Belay <abelay@novell.com>,
       Lee Revell <rlrevell@joe-job.com>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080311183149.0f44e603@mjolnir.drzeus.cx>
In-Reply-To: <20080311162026.012744cd@mjolnir.drzeus.cx>
References: <20080303231033.GB15255@one.firstfloor.org>
	<20080304040048.GA31562@codemonkey.org.uk>
	<20080304071423.0e6b71c1@mjolnir.drzeus.cx>
	<20080304181924.70aaf8c1@mjolnir.drzeus.cx>
	<924EFEDD5F540B4284297C4DC59F3DEEA77031@orsmsx423.amr.corp.intel.com>
	<20080305070201.0d16cd40@mjolnir.drzeus.cx>
	<20080305094023.6486ebdf@mjolnir.drzeus.cx>
	<20080306092730.4412d085@mjolnir.drzeus.cx>
	<20080309151659.63d54f38@mjolnir.drzeus.cx>
	<20080311085145.5fcf3186@mjolnir.drzeus.cx>
	<20080311104822.GC18917@one.firstfloor.org>
	<20080311162026.012744cd@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2008 16:20:26 +0100
Pierre Ossman <drzeus-list@drzeus.cx> wrote:

> On Tue, 11 Mar 2008 11:48:22 +0100
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > I have now found a very hacky workaround that is slightly better than
> > > disabling C3 altogether; making C3 exclusive to one core at a time. It
> > > seems to kill the noise and the system now spends 50% in C3, instead of
> > > 0%.
> > 
> > I suspect it won't do much of C3 if only one core is idle this way.
> > Most likely you just disabled C3 this way in a way invisible to software.
> > 
> 
> What a letdown... I'll pull out the old watt meter again and see if I can confirm that.
> 

It seems that you are correct Andi. Power usage is in line with C3 completely disabled. Bummer :/

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
