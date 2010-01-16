Return-Path: <linux-kernel-owner+w=401wt.eu-S1752884Ab0APWV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab0APWV3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 17:21:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567Ab0APWV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 17:21:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39200 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555Ab0APWV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 17:21:27 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>, omegamoon@gmail.com
Subject: Re: [suspend/resume] Re: userspace notification from module
Date: Sat, 16 Jan 2010 23:21:53 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: "Bart?omiej Zimo?" <uzi18@o2.pl>, Andy Walls <awalls@radix.net>,
       Daniel Borkmann <danborkmann@googlemail.com>,
       linux-kernel@vger.kernel.org, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       Dirk@opfer-online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com,
       "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, eric.y.miao@gmail.com, utx@penguin.cz,
       zaurus-devel@www.linuxtogo.org
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl> <201001162307.48085.rjw@sisk.pl> <20100116221454.GA8425@elf.ucw.cz>
In-Reply-To: <20100116221454.GA8425@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001162321.53616.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 January 2010, Pavel Machek wrote:
> Hi!
> 
> > > Agreed, but so what? On PC, machine would power off at that
> > > point. That would surprise the apps, too.
> > > 
> > > Basically new enough userland should not make battery run low enough
> > > for either emergency power off or emergency suspend.
> > 
> > I wonder how it is supposed to achieve that without knowing the current battery
> > status.  Do you mean it should poll the battery driver?
> 
> That's besides point, is it?

Well, mentioned that first. :-)

> Usual kernel<->user interfaces should apply here.

And we're talking about the design of these, aren't we?  The notification about
the critical battery status sent to the user space is a part of the kernel-user
space interface too, after all.

Rafael
