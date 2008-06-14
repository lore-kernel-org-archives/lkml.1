Return-Path: <linux-kernel-owner+w=401wt.eu-S1757302AbYFNLSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbYFNLSw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 07:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbYFNLSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 07:18:40 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:44050 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861AbYFNLSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 07:18:11 -0400
Date: Sat, 14 Jun 2008 14:18:06 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, david-b@pacbell.net,
       Ingo Molnar <mingo@elte.hu>, Lior Dotan <liodot@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [rtc-linux] Re: [Bug 10866] /dev/rtc was missing until I
	disabled CONFIG_RTC_CLASS
Message-ID: <20080614111806.GF1716@cs181133002.pp.htv.fi>
References: <GIilET9wkhI.A.JzB.81vSIB@albercik> <200806131343.41213.david-b@pacbell.net> <20080613210257.GA529@elte.hu> <200806131538.54254.david-b@pacbell.net> <20080614113535.4d611e07@i1501.lan.towertech.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080614113535.4d611e07@i1501.lan.towertech.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2008 at 11:35:35AM +0200, Alessandro Zummo wrote:
> On Fri, 13 Jun 2008 15:38:54 -0700
> David Brownell <david-b@pacbell.net> wrote:
> 
> > They can continue working just fine with *only* the legacy RTC.
> > If they stuck with defaults, no problems appear.  (Modulo the
> > fact that bitrot is setting in.)
> > 
> > The only thing that causes the least hiccup is someone who was
> > for a while using a bogus (and non-default) configuration.
> > 
> > Given a bogus configuration, how should it be fixed?  There
> > can be several solutions, and the right answer for one system
> > will always be the right one for another.  So any approach
> > that doesn't expect a human to select options sometimes will
> > be inherently wrong in various cases.
> 
>  I agree with david. oldconfig cannot be made to fix every possible
>  manual misconfiguration that has been introduced by the user, even
>  those that, by chance, just worked.
> 
>  The actual Kconfig will handle pretty well the transition from
>  a good config. where good is different from working-by-chance.
> 
>  There are far too many people that just keep pressing Y
>  when a new kernel option appears without even considering what would
>  happen or reading the help.

If Lior's problem was due to something like CONFIG_RTC_CLASS=y, 
CONFIG_RTC_DRV_CMOS=n that's a kernel configuration that would
anyway break when the old driver gets removed, and it just broke
earlier.

Everyone seems to focus on this kconfig related case, what about my 
point of no /dev/rtc with a static /dev ? When talking about existing 
setups and embedded systems that's a real issue for some systems.

>  Best regards,
> 
>  Alessandro Zummo,

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

