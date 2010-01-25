Return-Path: <linux-kernel-owner+w=401wt.eu-S1753033Ab0AYMrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab0AYMrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 07:47:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324Ab0AYMra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 07:47:30 -0500
Received: from www.tglx.de ([62.245.132.106]:38037 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503Ab0AYMr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 07:47:29 -0500
Date: Mon, 25 Jan 2010 13:45:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>, Mark Knecht <markknecht@gmail.com>,
       John Kacur <jkacur@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: ARM fixes for 2.6.31.12-rt20
In-Reply-To: <20100125103341.GA3712@pengutronix.de>
Message-ID: <alpine.LFD.2.00.1001251142210.2906@localhost.localdomain>
References: <alpine.LFD.2.00.0908212319370.1769@localhost.localdomain> <alpine.LFD.2.00.0908261910460.2888@localhost.localdomain> <alpine.LFD.2.00.0908282326460.19335@localhost.localdomain> <alpine.LFD.2.00.0909152257590.8957@localhost.localdomain>
 <alpine.LFD.2.00.0909190027400.2889@localhost.localdomain> <alpine.LFD.2.00.0910061210400.2646@localhost.localdomain> <alpine.LFD.2.00.0910141115020.9428@localhost.localdomain> <alpine.LFD.2.00.0911061743210.12138@localhost.localdomain>
 <alpine.LFD.2.00.0911101326280.2725@localhost.localdomain> <alpine.LFD.2.00.1001212102220.2906@localhost.localdomain> <20100125103341.GA3712@pengutronix.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-568851917-1264423530=:2906"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-568851917-1264423530=:2906
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Mon, 25 Jan 2010, Uwe Kleine-König wrote:
> Hello,
> 
> I have done build tests for ARCH=arm on 2.6.31.12-rt20 and to fix most
> platforms I needed to cherry pick three commits from post-2.6.31
> mainline:
> 
> 	9fd868f ([WATCHDOG] davinci: use clock framework for timer frequency)
> 	b9696ea (net: Fix IXP 2000 network driver building.)
> 	0bfb34f (ARM: S3C2440: mini2440: Fix missing CONFIG_S3C_DEV_USB_HOST)

I have a hard time to see, why these patches fix most
platforms. AFAICT tell each one is fixing a single mach or board. 

> (One of these fails to cleanly apply on top of 2.6.31.12-rt20 so I made
> them available at
> 
> 	git://git.pengutronix.de/git/ukl/linux-2.6.git rt/arm
> 
> based on tip/rt/arm).  Then there is a problem with highmem (only on
> ARM).  A fix was discussed already earlier, but as there havn't been
> anyone volunteering to test it, Thomas didn't take it.  As I don't have
> a machine needing highmem I cannot test either.  So I just resend it as
> it changed slightly since the last post to keep it in the archives (or
> for the case Thomas wants to take it now).

No, I don't. Thanks,

    tglx



--8323328-568851917-1264423530=:2906--
