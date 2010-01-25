Return-Path: <linux-kernel-owner+w=401wt.eu-S1752984Ab0AYNHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab0AYNHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 08:07:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000Ab0AYNHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 08:07:37 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46574 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab0AYNHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 08:07:36 -0500
Date: Mon, 25 Jan 2010 14:07:25 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
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
Message-ID: <20100125130725.GA8159@pengutronix.de>
References: <alpine.LFD.2.00.0908282326460.19335@localhost.localdomain> <alpine.LFD.2.00.0909152257590.8957@localhost.localdomain> <alpine.LFD.2.00.0909190027400.2889@localhost.localdomain> <alpine.LFD.2.00.0910061210400.2646@localhost.localdomain> <alpine.LFD.2.00.0910141115020.9428@localhost.localdomain> <alpine.LFD.2.00.0911061743210.12138@localhost.localdomain> <alpine.LFD.2.00.0911101326280.2725@localhost.localdomain> <alpine.LFD.2.00.1001212102220.2906@localhost.localdomain> <20100125103341.GA3712@pengutronix.de> <alpine.LFD.2.00.1001251142210.2906@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.1001251142210.2906@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

On Mon, Jan 25, 2010 at 01:45:26PM +0100, Thomas Gleixner wrote:
> On Mon, 25 Jan 2010, Uwe Kleine-König wrote:
> > Hello,
> > 
> > I have done build tests for ARCH=arm on 2.6.31.12-rt20 and to fix most
> > platforms I needed to cherry pick three commits from post-2.6.31
> > mainline:
> > 
> > 	9fd868f ([WATCHDOG] davinci: use clock framework for timer frequency)
> > 	b9696ea (net: Fix IXP 2000 network driver building.)
> > 	0bfb34f (ARM: S3C2440: mini2440: Fix missing CONFIG_S3C_DEV_USB_HOST)
> 
> I have a hard time to see, why these patches fix most
> platforms. AFAICT tell each one is fixing a single mach or board. 
That's right.  The more exact wording is:  After cherry picking these
most platforms (i.e. 133/137) compile without error.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
