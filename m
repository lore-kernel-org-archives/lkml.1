Return-Path: <linux-kernel-owner+w=401wt.eu-S1753127Ab0ACVuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab0ACVuB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 16:50:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036Ab0ACVt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 16:49:59 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50877 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945Ab0ACVt6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 16:49:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: =?utf-8?q?Bart=C5=82omiej_Zimo=C5=84?= <uzi18@o2.pl>
Subject: Re: [suspend/resume] Re: userspace notification from module
Date: Sun, 3 Jan 2010 22:50:36 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Andy Walls <awalls@radix.net>,
       Daniel Borkmann <danborkmann@googlemail.com>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl> <201001030029.22449.rjw@sisk.pl> <ff72e3e.3b5092ec.4b40d1ec.54407@o2.pl>
In-Reply-To: <ff72e3e.3b5092ec.4b40d1ec.54407@o2.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001032250.36235.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 January 2010, Bartłomiej Zimoń wrote:
> Dnia 3 stycznia 2010 0:29 	"Rafael J. Wysocki" <rjw@sisk.pl> napisał(a):
> > > - could be even used partialy by pm-utils
> > > - it is perfect just to notify about event
> > 
> > OK, but why exactly do _you_ need that to happen?
> > 
> > There's one important drawback of making the kernel generate the notification.
> > Namely, even if your userspace task is notified by the kernel of a PM event,
> > that doesn't mean it'll have the time to act upon that, because the kernel will
> > attempt to freeze it right after the notification has been sent.  This means
> > you'd need a way to make the kernel wait for your user space process to finish
> > it's job before continuing the suspend/hibernate process.  Otherwise it's not
> > going to be very useful.
> > 
> 
> So if it is bad idea, we could create more advenced implementation.
> i.e. IPC or callbacks for this kind of events.
> 
> There is vision in my mind to have alternative to pm-utils, 
> but even more powerfull and easy to implement in program.
> I could try to implement something like that.

I guess there's no other way to show people what you're up to, so please go
ahead and let me know if you need help.

Rafael
