Return-Path: <linux-kernel-owner+w=401wt.eu-S1759046AbXKTINt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759046AbXKTINt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 03:13:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756786AbXKTINl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 03:13:41 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59186 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756542AbXKTINk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 03:13:40 -0500
Date: Tue, 20 Nov 2007 00:11:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Lampard <mike@secnet.net.au>
Cc: Wim Van Sebroeck <wim@iguana.be>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Hans-Christian Egtvedt <hcegtvedt@atmel.com>,
       Samuel Tardieu <sam@rfc1149.net>, Jiri Slaby <jirislaby@gmail.com>,
       "Jorge Boncompte [ DTI2 ]" <jorge@dti2.net>
Subject: Re: [WATCHDOG] v2.6.24 Watchdog Device Drivers patches - part 4
Message-Id: <20071120001107.5614b251.akpm@linux-foundation.org>
In-Reply-To: <200711201344.15214.mike@secnet.net.au>
References: <20071119213220.GA3289@infomag.infomag.iguana.be>
	<200711201344.15214.mike@secnet.net.au>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007 13:44:13 +1030 Mike Lampard <mike@secnet.net.au> wrote:

> Hi
> On Tue, 20 Nov 2007 08:02:20 am Wim Van Sebroeck wrote:
> > Hi Linus,
> >
> > Please pull from 'master' branch of
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
> > or if master.kernel.org hasn't synced up yet:
> > 	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
> >
> > This will update the following files:
> >
> >  drivers/sbus/char/cpwatchdog.c    |    2
> >  drivers/watchdog/Kconfig          |   10
> >  drivers/watchdog/Makefile         |    1
> >  drivers/watchdog/at32ap700x_wdt.c |   69 ++++++
> >  drivers/watchdog/bfin_wdt.c       |    2
> >  drivers/watchdog/it8712f_wdt.c    |  400
> > ++++++++++++++++++++++++++++++++++++++ drivers/watchdog/w83697hf_wdt.c   | 
> >   4
> >  7 files changed, 481 insertions(+), 7 deletions(-)
> >
> > with these Changes:
> >
> > Author: Jorge Boncompte [DTI2] <jorge@dti2.net>
> > Date:   Mon Nov 19 15:09:21 2007 +0100
> >
> >     [WATCHDOG] IT8212F watchdog driver
> >
> >     This patch adds support for the ITE Tech Inc. IT8712F EC-LPC Super I/O
> >     chipset found on many Pentium III and AMD motherboards. Developed using
> > code from other watchdog drivers and the datasheet on ITE Tech homepage.
> >
> >     Signed-off-by: Jorge Boncompte <jorge@dti2.net>
> >     Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
> >
> > Author: Jiri Slaby <jirislaby@gmail.com>
> > Date:   Sat Nov 10 04:32:45 2007 +0100
> >
> 
> The following patch applied to the above diff adds support for the IT8716F 
> watchdog, which appears to be essentially the same as the IT8712F in all but 
> name.
> 

Please send patches with a suitably and carefully chosen Subject:.  We
don't want to call this patch "Re: [WATCHDOG] v2.6.24 Watchdog Device
Drivers patches - part 4".

I chose "it8712f_wdt.c: add support for the IT8716F watchdog".
