Return-Path: <linux-kernel-owner+w=401wt.eu-S1753005Ab0ACRUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005Ab0ACRUt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 12:20:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833Ab0ACRUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 12:20:47 -0500
Received: from rekin23.go2.pl ([193.17.41.16]:59169 "EHLO rekin23.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809Ab0ACRUr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 12:20:47 -0500
Subject: =?UTF-8?Q?Re:_[suspend/resume]_Re:_userspace_notification_from_module?=
From: =?UTF-8?Q?Bart=C5=82omiej_Zimo=C5=84?= <uzi18@o2.pl>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?Q?Andy_Walls?= <awalls@radix.net>,
       =?UTF-8?Q?Daniel_Borkmann?= <danborkmann@googlemail.com>,
       linux-kernel@vger.kernel.org,
       =?UTF-8?Q?pm_list?= <linux-pm@lists.linux-foundation.org>,
       =?UTF-8?Q?Alan_Stern?= <stern@rowland.harvard.edu>
In-Reply-To: <201001030029.22449.rjw@sisk.pl>
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl> <201001022201.04281.rjw@sisk.pl> <7cf4f51f.5fc2a5cd.4b3fc3ad.c849c@o2.pl> <201001030029.22449.rjw@sisk.pl>
Mime-Version: 1.0
Message-ID: <ff72e3e.3b5092ec.4b40d1ec.54407@o2.pl>
Date: Sun, 03 Jan 2010 18:20:44 +0100
X-Originator: 83.10.137.12
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 3 stycznia 2010 0:29 	"Rafael J. Wysocki" <rjw@sisk.pl> napisał(a):
> > - could be even used partialy by pm-utils
> > - it is perfect just to notify about event
> 
> OK, but why exactly do _you_ need that to happen?
> 
> There's one important drawback of making the kernel generate the notification.
> Namely, even if your userspace task is notified by the kernel of a PM event,
> that doesn't mean it'll have the time to act upon that, because the kernel will
> attempt to freeze it right after the notification has been sent.  This means
> you'd need a way to make the kernel wait for your user space process to finish
> it's job before continuing the suspend/hibernate process.  Otherwise it's not
> going to be very useful.
> 

So if it is bad idea, we could create more advenced implementation.
i.e. IPC or callbacks for this kind of events.

There is vision in my mind to have alternative to pm-utils, 
but even more powerfull and easy to implement in program.
I could try to implement something like that.

Rafael i'm open for Your suggestions.

Best regards.
Bartłomiej Zimoń
PLD Linux, Kadu Team, FreeRunner user
http://kadu-im.blogspot.com/

