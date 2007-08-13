Return-Path: <linux-kernel-owner+w=401wt.eu-S964908AbXHMWMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964908AbXHMWMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 18:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756714AbXHMWMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 18:12:41 -0400
Received: from er-systems.de ([85.25.136.202]:46501 "EHLO er-systems.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbXHMWMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 18:12:39 -0400
Date: Tue, 14 Aug 2007 00:12:34 +0200 (CEST)
From: Thomas Voegtle <tv@lio96.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: 2.6.23-rc2 swsusp, suddenly increased uptime
In-Reply-To: <200708132349.52763.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.63.0708140009110.32395@er-systems.de>
References: <Pine.LNX.4.63.0708122137130.25343@er-systems.de>
 <200708132306.27587.rjw@sisk.pl> <Pine.LNX.4.63.0708132325580.29791@er-systems.de>
 <200708132349.52763.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="425052808-121490045-1187043154=:32395"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--425052808-121490045-1187043154=:32395
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT

On Mon, 13 Aug 2007, Rafael J. Wysocki wrote:

> On Monday, 13 August 2007 23:31, Thomas Voegtle wrote:
> > On Mon, 13 Aug 2007, Rafael J. Wysocki wrote:
> > 
> > > On Sunday, 12 August 2007 21:39, Thomas Voegtle wrote:
> > > > 
> > > > Hi,
> > > > 
> > > > today I saw this (output from my suspend script):
> > > > 
> > > > -> woke up at Sun Aug 12 11:39:17 CEST 2007
> > > > -> uptime is
> > > >  11:39am  up 8 days  0:41,  10 users,  load average: 26.12, 6.35, 2.17
> > > > 
> > > > 
> > > > Then I did a software suspend. After waking up, I saw this:
> > > > 
> > > > 
> > > > -> woke up at Sun Aug 12 14:41:56 CEST 2007
> > > > -> uptime is
> > > >   2:41pm  up 44 days  9:11,  12 users,  load average: 35.17, 9.17, 3.33
> > 
> > I just want to add, I built 2.6.23-rc2 on Aug 4th and this happened on Aug 
> > 12 and I suspend once a day. And the only thing which was odd was the 
> > uptime, nothing else.
> > 
> > I rebooted with 2.6.23-rc3 today, so the odd uptime is gone.
> > Should I try 8 suspend cycles or something to reproduce it again?
> 
> Well, if you can, please try to do something like this.

I tried 20 suspend cycles, but this time with 
 echo reboot > /sys/power/disk

Nothing special happend.

I could try with "echo shutdown" if this makes sense, tomorrow.
Just let me know.

      Thomas

-- 
 Thomas Vögtle    email: thomas@voegtle-clan.de
 ----- http://www.voegtle-clan.de/thomas ------
--425052808-121490045-1187043154=:32395--
