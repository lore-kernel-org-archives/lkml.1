Return-Path: <linux-kernel-owner+w=401wt.eu-S1752038Ab0ABWeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab0ABWeL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 17:34:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298Ab0ABWeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 17:34:10 -0500
Received: from mailout1.go2.pl ([193.17.41.11]:60111 "EHLO mailout1.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab0ABWeJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 17:34:09 -0500
Subject: =?UTF-8?Q?Re:_[suspend/resume]_Re:_userspace_notification_from_module?=
From: =?UTF-8?Q?Bart=C5=82omiej_Zimo=C5=84?= <uzi18@o2.pl>
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Message-ID: <5c6ee5a9.5b103961.4b3fc9de.b6cf4@o2.pl>
Date: Sat, 02 Jan 2010 23:34:06 +0100
X-Originator: 83.12.131.34
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 2 stycznia 2010 22:01 "Rafael J. Wysocki" <rjw@sisk.pl> napisał(a):

> On Saturday 02 January 2010, Bartłomiej Zimoń wrote:
> > Dnia 2 stycznia 2010 16:56 	Daniel Borkmann <danborkmann@googlemail.com> napisał(a):
> > > Hi Andy,
> > > 
> > > 2010/1/2 Andy Walls <awalls@radix.net>:
> > > > Why not:
> > > >
> > > > a. write a module that implements a device node that supports poll(),
> > > > and
> > > >
> > > > b. have a user space process select() on the fd for read or exception
> > > > notification
> > > >
> > > > ?
> > > 
> > > This is, of course, another possible solution that is more "cleaner"
> > > than the one with the signals.
> > > Then, your userspace program would have another thread polling for the
> > > device node. Question is which timeout would be appropriate to be "CPU
> > > friendly" and to keep notification latency short?
> > > 
> > 
> > Just need as fast as possible solution and on the other hand acceptable for kernel sources.
> > Usually programs needs just to disconnect something or set one flag.
> > Even if program will have no time for this it could be enough just to send this precious info.
> 
> Perhaps I don't understand correctly what you're trying to achieve, but at the
> moment suspend is always started from user space, this way or another, and on
> the majority (all?) of the modern distros pm-utils is involved in that.
> So, why don't you provide a pm-utils hook for your process (like, for example,
> NetworkManager)?
> 

Thanks for Your answare.
Some points of my idea:
- don't think everyone want to use pm-utils (didn't say it is bad)
- this code is standard for all implementation of suspend/hibernate/resume
- it is small
- it have less overhead, dont need dbus and all rest services.
- could be even used partialy by pm-utils
- it is perfect just to notify about event

Some opposits:
- program will have less time to do what it want than with pm-utils
- all rest

Please correct me if i'm wrong.

Best regards
Bartłomiej Zimoń
PLD Linux, Kadu Team

