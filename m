Return-Path: <linux-kernel-owner+w=401wt.eu-S940034AbXHMVci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940034AbXHMVci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 17:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932988AbXHMVbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 17:31:42 -0400
Received: from er-systems.de ([85.25.136.202]:50274 "EHLO er-systems.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934219AbXHMVbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 17:31:40 -0400
Date: Mon, 13 Aug 2007 23:31:38 +0200 (CEST)
From: Thomas Voegtle <tv@lio96.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Thomas Voegtle <tv@lio96.de>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: 2.6.23-rc2 swsusp, suddenly increased uptime
In-Reply-To: <200708132306.27587.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.63.0708132325580.29791@er-systems.de>
References: <Pine.LNX.4.63.0708122137130.25343@er-systems.de>
 <200708132306.27587.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="425052808-1259902182-1187040698=:29791"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--425052808-1259902182-1187040698=:29791
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT

On Mon, 13 Aug 2007, Rafael J. Wysocki wrote:

> On Sunday, 12 August 2007 21:39, Thomas Voegtle wrote:
> > 
> > Hi,
> > 
> > today I saw this (output from my suspend script):
> > 
> > -> woke up at Sun Aug 12 11:39:17 CEST 2007
> > -> uptime is
> >  11:39am  up 8 days  0:41,  10 users,  load average: 26.12, 6.35, 2.17
> > 
> > 
> > Then I did a software suspend. After waking up, I saw this:
> > 
> > 
> > -> woke up at Sun Aug 12 14:41:56 CEST 2007
> > -> uptime is
> >   2:41pm  up 44 days  9:11,  12 users,  load average: 35.17, 9.17, 3.33

I just want to add, I built 2.6.23-rc2 on Aug 4th and this happened on Aug 
12 and I suspend once a day. And the only thing which was odd was the 
uptime, nothing else.

I rebooted with 2.6.23-rc3 today, so the odd uptime is gone.
Should I try 8 suspend cycles or something to reproduce it again?

 
> Can you please boot the kernel in the minimal configuration (init=/bin/bash)
> and try to hibernate, ie.
> 
> # mount /proc
> # mount /sys
> # swapon -a
> # echo disk > /sys/power/state
> 
> Also, please check if anything changes if you do
> 
> # echo shutdown > /sys/power/disk
> 
> before the last command above.

I did, but what could change? I did not see anything, nothing dmesg, no 
odd uptime etc.

      Thomas

-- 
 Thomas Vögtle    email: thomas@voegtle-clan.de
 ----- http://www.voegtle-clan.de/thomas ------
--425052808-1259902182-1187040698=:29791--
