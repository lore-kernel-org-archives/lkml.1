Return-Path: <linux-kernel-owner+w=401wt.eu-S1753046Ab0ADBGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab0ADBGX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 20:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025Ab0ADBGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 20:06:22 -0500
Received: from mailout1.go2.pl ([193.17.41.11]:54310 "EHLO mailout1.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752990Ab0ADBGT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 20:06:19 -0500
Subject: =?UTF-8?Q?Re:_[suspend/resume]_Re:_userspace_notification_from_module?=
From: =?UTF-8?Q?Bart=C5=82omiej_Zimo=C5=84?= <uzi18@o2.pl>
To: linux-kernel@vger.kernel.org
In-Reply-To: <a522f3c.3bab16d1.4b413b9c.ec43@o2.pl>
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl> <54ac764e.502c1a33.4b4129c3.9dc1b@o2.pl> <201001040045.39517.rjw@sisk.pl> <a522f3c.3bab16d1.4b413b9c.ec43@o2.pl>
Mime-Version: 1.0
Message-ID: <5c4811b9.70453bcc.4b413f05.574de@o2.pl>
Date: Mon, 04 Jan 2010 02:06:13 +0100
X-Originator: 83.12.131.34
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 4 stycznia 2010 1:51 	Bartłomiej Zimoń <uzi18@o2.pl> napisał(a):
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

not user.c but: kernel/power/main.c

Best regards.
Bartłomiej Zimoń
PLD Linux, Kadu Team, FreeRunner user
http://kadu-im.blogspot.com/
 

