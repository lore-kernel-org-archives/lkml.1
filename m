Return-Path: <linux-kernel-owner+w=401wt.eu-S1757893AbYFMVUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893AbYFMVUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 17:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbYFMVU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 17:20:26 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:48941 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392AbYFMVUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 17:20:24 -0400
Date: Sat, 14 Jun 2008 00:20:23 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Lior Dotan <liodot@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       David Brownell <dbrownell@users.sourceforge.net>, a.zummo@towertech.it,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org, rtc-linux@googlegroups.com
Subject: Re: [Bug 10866] /dev/rtc was missing until I disabled
	CONFIG_RTC_CLASS
Message-ID: <20080613212023.GB1716@cs181133002.pp.htv.fi>
References: <GIilET9wkhI.A.JzB.81vSIB@albercik> <dCRO4tbfLzK.A.rFC.L2vSIB@albercik> <20080613193302.GA1716@cs181133002.pp.htv.fi> <a5bf86a80806131255w704745d7mc109c13669ac9c68@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a5bf86a80806131255w704745d7mc109c13669ac9c68@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2008 at 10:55:38PM +0300, Lior Dotan wrote:
> On Fri, Jun 13, 2008 at 10:33 PM, Adrian Bunk <bunk@kernel.org> wrote:
> > On Sat, Jun 07, 2008 at 10:42:57PM +0200, Rafael J. Wysocki wrote:
> >> This message has been generated automatically as a part of a report
> >> of recent regressions.
> >>
> >> The following bug entry is on the current list of known regressions
> >> from 2.6.25.  Please verify if it still should be listed.
> >>
> >>
> >> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=10866
> >> Subject               : /dev/rtc was missing until I disabled CONFIG_RTC_CLASS
> >> Submitter     : Lior Dotan <liodot@gmail.com>
> >> Date          : 2008-06-05 15:04 (3 days old)
> >> References    : http://marc.info/?l=linux-kernel&amp;m=121267834521432&amp;w=4
> >
> > Where are we regarding this entry in the 2.6.26-rc regression list?
> >
> > I'd agree with David that CONFIG_RTC_CLASS disabling CONFIG_RTC is a fix
> > and not a 2.6.26-rc regression.
> >
> > Does anyone disagree with this?
> >
> >
> > I'm not sure whether this was Lior's problem or another issue I'm seeing
> > on my computer (static /dev, no udev):
> >
> > /dev/rtc (major 10, minor 135) does not seem to exist, and I'd call this
> > a functional regression of the new drivers.
> >
> > Could this be fixed?
> 
> I don't know if it helps you to decide but the way I got to this 
> configuration is by copying my working 2.6.25 .config file and running 
> make oldconfig. I think this scenario is common when upgrading to a 
> newer version so you should make sure it doesn't generate an invalid 
> configuration.

What is the output of "grep RTC_ .config" on your old .config?

> Lior.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

