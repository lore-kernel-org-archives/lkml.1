Return-Path: <linux-kernel-owner+w=401wt.eu-S1756497Ab0AFWrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab0AFWrz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 17:47:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756480Ab0AFWry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 17:47:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40914 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756459Ab0AFWrx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 17:47:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: =?utf-8?q?Bart=C5=82omiej_Zimo=C5=84?= <uzi18@o2.pl>
Subject: Re: [linux-pm] [suspend/resume] Re: userspace 
 =?utf-8?q?notification=09_from?= module
Date: Wed, 6 Jan 2010 23:48:13 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, aeriksson@fastmail.fm,
       stefan.seyfried@googlemail.com, linux-pm@lists.linux-foundation.org,
       danborkmann@googlemail.com, awalls@radix.net
References: <1df13dac.5ba05e5c.4b43e1e2.120e@o2.pl>
In-Reply-To: <1df13dac.5ba05e5c.4b43e1e2.120e@o2.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001062348.13137.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 January 2010, Bartłomiej Zimoń wrote:
> Dnia 6 stycznia 2010 0:05 	"Rafael J. Wysocki" <rjw@sisk.pl> napisał(a):
> > Well, I think you have some specific issue with pm-utils, but you're not
> > telling us what it is.  So, why exactly is pm-utils not suitable for your
> > needs?
> > 
> 
> Rafael to be honest it's more dbus specific. I'm talking about 
> dbus as it is standard for system<->apps communication.

That was my impression. :-)

Well, I don't like dbus too, but ...

> But please understand if we'll create kernel device with simple pm notification
> It could be hooked by udev and next ... by DeviceKit-power/upower and after that
> we have real standard. But to have this we must export "power" device - something 
> like my proof-of-concept module. This could be realy good start.

... that doesn't make me think it should be sneakily replaced with "magic"
kernel modules or similar stuff.

As I already said many times in this thread before, please look for a solution
in the user space.

Rafael
