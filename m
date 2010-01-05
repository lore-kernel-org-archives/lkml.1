Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461Ab0AEVXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab0AEVXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 16:23:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755325Ab0AEVXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 16:23:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34128 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755301Ab0AEVXJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 16:23:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: =?utf-8?q?Bart=C5=82omiej_Zimo=C5=84?= <uzi18@o2.pl>
Subject: Re: [linux-pm] [suspend/resume] Re: userspace notification from module
Date: Tue, 5 Jan 2010 22:23:21 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Anders Eriksson <aeriksson@fastmail.fm>,
       linux-pm@lists.linux-foundation.org, awalls@radix.net,
       danborkmann@googlemail.com
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl> <20100105090706.751D233C4B0@tippex.mynet.homeunix.org> <7e89c5d.77f82021.4b43a8d7.127e1@o2.pl>
In-Reply-To: <7e89c5d.77f82021.4b43a8d7.127e1@o2.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001052223.21964.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 January 2010, Bartłomiej Zimoń wrote:
> Dnia 5 stycznia 2010 10:07 	Anders Eriksson <aeriksson@fastmail.fm> napisał(a):
> > 
> > rjw@sisk.pl said:
> > >> > I don't see a problem with this in principle, although I don't think signals
> > >> > are very suitable for this particular purpose, because you need two-way
> > >> > communication between the power manager and the processes it's going to
> > >> > notify (because it has to wait for the processes to finish their preparations
> > >> > and to tell it that they are ready). 
> > 
> > Wouldn't there need to be dependecy tracking for the userspace processes? A 
> > process couldn't signal "done" until it know there's no more work to do, which 
> > requires all other processes to finish up first.
> > 
> 
> Not all processes will need pm notification.
> 
> Just in case, could this "power manager" be provided as userspace
> driver for kernel (for example compiled as UIO)?

I don't really understand why you want to do that in the kernel.  Is there
any particular reason why this cannot be done in the user space?

Rafael
