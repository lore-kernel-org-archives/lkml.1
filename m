Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007Ab0ADTnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab0ADTnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 14:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995Ab0ADTnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 14:43:17 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55670 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993Ab0ADTnQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 14:43:16 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: =?utf-8?q?Bart=C5=82omiej_Zimo=C5=84?= <uzi18@o2.pl>
Subject: Re: [suspend/resume] Re: userspace notification from module
Date: Mon, 4 Jan 2010 20:43:26 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, awalls@radix.net, danborkmann@googlemail.com,
       linux-pm@lists.linux-foundation.org, stern@rowland.harvard.edu
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl> <201001040045.39517.rjw@sisk.pl> <a522f3c.3bab16d1.4b413b9c.ec43@o2.pl>
In-Reply-To: <a522f3c.3bab16d1.4b413b9c.ec43@o2.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001042043.27037.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 January 2010, Bartłomiej Zimoń wrote:
> Dnia 4 stycznia 2010 0:45 "Rafael J. Wysocki" <rjw@sisk.pl> napisał(a):
> > On Monday 04 January 2010, Bartłomiej Zimoń wrote:
> > > Thx Rafael - now it clear to me.
> > > And what do You think about sending extra signals to processes?
> > 
> > I don't see a problem with this in principle, although I don't think signals
> > are very suitable for this particular purpose, because you need two-way
> > communication between the power manager and the processes it's going to
> > notify (because it has to wait for the processes to finish their preparations
> > and to tell it that they are ready).
> > 
> > For this purpose it's better to have a file descriptor you can block on (like a
> > socket or a pipe) while the other side is doing it's job.
> > 
> 
> So let's create one in power/user.c or use /sys/power/state for this :)

I don't see a good reason, really.

Rafael
