Return-Path: <linux-kernel-owner+w=401wt.eu-S1764600AbXH1Tdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764600AbXH1Tdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932250AbXH1TY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:24:26 -0400
Received: from er-systems.de ([85.25.136.202]:33819 "EHLO er-systems.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761515AbXH1TYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:24:24 -0400
Date: Tue, 28 Aug 2007 21:24:20 +0200 (CEST)
From: Thomas Voegtle <tv@lio96.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Thomas Voegtle <tv@lio96.de>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: 2.6.23-rc2 swsusp, suddenly increased uptime
In-Reply-To: <200708140035.24240.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.63.0708282122220.16484@er-systems.de>
References: <Pine.LNX.4.63.0708122137130.25343@er-systems.de>
 <200708132349.52763.rjw@sisk.pl> <Pine.LNX.4.63.0708140009110.32395@er-systems.de>
 <200708140035.24240.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="425052808-58022181-1188329060=:16484"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--425052808-58022181-1188329060=:16484
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT

On Tue, 14 Aug 2007, Rafael J. Wysocki wrote:

> On Tuesday, 14 August 2007 00:12, Thomas Voegtle wrote:
> > On Mon, 13 Aug 2007, Rafael J. Wysocki wrote:
> > 
> > > On Monday, 13 August 2007 23:31, Thomas Voegtle wrote:
> > > > On Mon, 13 Aug 2007, Rafael J. Wysocki wrote:
> > > > 
> > > > > On Sunday, 12 August 2007 21:39, Thomas Voegtle wrote:
> > > > > > 
> > > > > > Hi,
> > > > > > 
> > > > > > today I saw this (output from my suspend script):
> > > > > > 
> > > > > > -> woke up at Sun Aug 12 11:39:17 CEST 2007
> > > > > > -> uptime is
> > > > > >  11:39am  up 8 days  0:41,  10 users,  load average: 26.12, 6.35, 2.17
> > > > > > 
> > > > > > 
> > > > > > Then I did a software suspend. After waking up, I saw this:
> > > > > > 
> > > > > > 
> > > > > > -> woke up at Sun Aug 12 14:41:56 CEST 2007
> > > > > > -> uptime is
> > > > > >   2:41pm  up 44 days  9:11,  12 users,  load average: 35.17, 9.17, 3.33
> > > > 
> > > > I just want to add, I built 2.6.23-rc2 on Aug 4th and this happened on Aug 
> > > > 12 and I suspend once a day. And the only thing which was odd was the 
> > > > uptime, nothing else.
> > > > 
> > > > I rebooted with 2.6.23-rc3 today, so the odd uptime is gone.
> > > > Should I try 8 suspend cycles or something to reproduce it again?
> > > 
> > > Well, if you can, please try to do something like this.
> > 
> > I tried 20 suspend cycles, but this time with 
> >  echo reboot > /sys/power/disk
> > 
> > Nothing special happend.
> > 
> > I could try with "echo shutdown" if this makes sense, tomorrow.
> > Just let me know.
> 
> Please try "platform" (ie. the default).  "shutdown" is very similar to
> "reboot", so I think it'll behave correctly.

I do not have platform. => cat /sys/power/disk
test testproc [shutdown] reboot 

Now are 14 days gone and my uptime is 14 days.

Many suspend/resume cycles were made (is there any counter you could see 
how many?).
I tried everything with 2.6.23-rc3 to reproduce this but I could not. I 
will reboot in to 2.6.23-rc4 now.

      Thomas

-- 
 Thomas Vögtle    email: thomas@voegtle-clan.de
 ----- http://www.voegtle-clan.de/thomas ------
--425052808-58022181-1188329060=:16484--
