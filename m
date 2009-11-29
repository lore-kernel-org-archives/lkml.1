Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbZK2Ioo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbZK2Ioo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 03:44:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbZK2Ion
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 03:44:43 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47334 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143AbZK2Iok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 03:44:40 -0500
Date: Sun, 29 Nov 2009 09:43:52 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: Corentin Chary <corentincj@iksaif.net>, Arve Hj??nnev??g <arve@google.com>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Chih-Wei Huang <cwhuang@linux.org.tw>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] staging/android fixes
Message-ID: <20091129084351.GD1530@ucw.cz>
References: <1259397915-762-1-git-send-email-corentincj@iksaif.net> <a55d774e0911280219s69729b54l544660aac4b2197@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a55d774e0911280219s69729b54l544660aac4b2197@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Here is a patch to fix build for android specifics drivers.
> >
> > What we should do next to prevent them from being removed in 2.6.23 ?
> >
> > Is there any chance that all android stuff would be merged one day ?
> > Actually, we got a working 2.6.32 kernel for android here (with wakelock, ashm, etc..):
> > http://git.iksaif.net/?p=android-x86/kernel;a=shortlog;h=refs/heads/android-x86-backport
> 
> Arve's done a few revisions of the wakelock code with the linux-pm
> list, and I know he's planning on trying to work through the remaining
> issues (as I recall there was some discussion on read/write vs ioctl
> interfaces to userspace) in the near future.
> 
> This really is the one piece that has the most impact on everything
> else -- maintaining versions of the various platform hardware drivers
> with and without wakelock support is messy.

It is really not that bad. Yes, it touches most drivers, but it is few
lines per driver and easy to remove.

Waiting for wakelocks (1year plus, AFAICT) before merging hw drivers
seems like very slow way forward.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
