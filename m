Return-Path: <linux-kernel-owner+w=401wt.eu-S1752467Ab0ABVAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab0ABVAp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 16:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369Ab0ABVAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 16:00:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49384 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344Ab0ABVAo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 16:00:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: =?utf-8?q?Bart=C5=82omiej_Zimo=C5=84?= <uzi18@o2.pl>
Subject: Re: [suspend/resume] Re: userspace notification from module
Date: Sat, 2 Jan 2010 22:01:04 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Andy Walls <awalls@radix.net>,
       Daniel Borkmann <danborkmann@googlemail.com>,
       linux-kernel@vger.kernel.org
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl> <6f52f5b81001020756i73fbb137if1af8ac8b306f6ba@mail.gmail.com> <ddef1cf.2c9460e3.4b3f8fd5.c10cd@o2.pl>
In-Reply-To: <ddef1cf.2c9460e3.4b3f8fd5.c10cd@o2.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001022201.04281.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 January 2010, Bartłomiej Zimoń wrote:
> Dnia 2 stycznia 2010 16:56 	Daniel Borkmann <danborkmann@googlemail.com> napisał(a):
> > Hi Andy,
> > 
> > 2010/1/2 Andy Walls <awalls@radix.net>:
> > > Why not:
> > >
> > > a. write a module that implements a device node that supports poll(),
> > > and
> > >
> > > b. have a user space process select() on the fd for read or exception
> > > notification
> > >
> > > ?
> > 
> > This is, of course, another possible solution that is more "cleaner"
> > than the one with the signals.
> > Then, your userspace program would have another thread polling for the
> > device node. Question is which timeout would be appropriate to be "CPU
> > friendly" and to keep notification latency short?
> > 
> 
> Just need as fast as possible solution and on the other hand acceptable for kernel sources.
> Usually programs needs just to disconnect something or set one flag.
> Even if program will have no time for this it could be enough just to send this precious info.

Perhaps I don't understand correctly what you're trying to achieve, but at the
moment suspend is always started from user space, this way or another, and on
the majority (all?) of the modern distros pm-utils is involved in that.
So, why don't you provide a pm-utils hook for your process (like, for example,
NetworkManager)?

Rafael
