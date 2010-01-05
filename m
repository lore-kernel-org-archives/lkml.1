Return-Path: <linux-kernel-owner+w=401wt.eu-S932173Ab0AEWMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab0AEWMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 17:12:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932102Ab0AEWMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 17:12:22 -0500
Received: from mailout1.go2.pl ([193.17.41.11]:43144 "EHLO mailout1.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932099Ab0AEWMV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 17:12:21 -0500
Subject: =?UTF-8?Q?Re:_[linux-pm]_[suspend/resume]_Re:_userspace_notification?=
	=?UTF-8?Q?_from_module?=
From: =?UTF-8?Q?Bart=C5=82omiej_Zimo=C5=84?= <uzi18@o2.pl>
To: linux-kernel@vger.kernel.org
Cc: uzi18@o2.pl, rjw@sisk.pl,
       =?UTF-8?Q?Anders_Eriksson?= <aeriksson@fastmail.fm>,
       linux-pm@lists.linux-foundation.org, awalls@radix.net,
       danborkmann@googlemail.com
In-Reply-To: <201001052223.21964.rjw@sisk.pl>
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl> <20100105090706.751D233C4B0@tippex.mynet.homeunix.org> <7e89c5d.77f82021.4b43a8d7.127e1@o2.pl> <201001052223.21964.rjw@sisk.pl>
Mime-Version: 1.0
Message-ID: <16a1b165.2fdc37c6.4b43b943.c6733@o2.pl>
Date: Tue, 05 Jan 2010 23:12:19 +0100
X-Originator: 83.12.131.34
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 5 stycznia 2010 22:23 	"Rafael J. Wysocki" <rjw@sisk.pl> napisał(a):
> On Tuesday 05 January 2010, Bartłomiej Zimoń wrote:
> > Dnia 5 stycznia 2010 10:07 	Anders Eriksson <aeriksson@fastmail.fm> napisał(a):
> > > 
> > > rjw@sisk.pl said:
> > > >> > I don't see a problem with this in principle, although I don't think signals
> > > >> > are very suitable for this particular purpose, because you need two-way
> > > >> > communication between the power manager and the processes it's going to
> > > >> > notify (because it has to wait for the processes to finish their preparations
> > > >> > and to tell it that they are ready). 
> > > 
> > > Wouldn't there need to be dependecy tracking for the userspace processes? A 
> > > process couldn't signal "done" until it know there's no more work to do, which 
> > > requires all other processes to finish up first.
> > > 
> > 
> > Not all processes will need pm notification.
> > 
> > Just in case, could this "power manager" be provided as userspace
> > driver for kernel (for example compiled as UIO)?
> 
> I don't really understand why you want to do that in the kernel.  Is there
> any particular reason why this cannot be done in the user space?
> 

Problem is with notification from pm-utils. Dbus for session is only 
user session waid and it is almost imposible to send something 
from systembus or it needs lots of magic.

Even if i'll use pm-utils, must provide way to notify my app.
Looks like no standard way here, that's bad, every app has it's own?

I think this way - if kernel is processes manager and if it sends
"some unknown" signal to every process before kernel suspend so why
not send sepcific and known signal instread.

But now we have DeviceKit-power/upower whatever but it doesn't provide
this feature or something simmilar to relay on.

Best regards.
Bartłomiej Zimoń
PLD Linux, Kadu Team, FreeRunner user
http://kadu-im.blogspot.com/

