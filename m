Return-Path: <linux-kernel-owner+w=401wt.eu-S1759197AbZEZXLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759197AbZEZXLO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758978AbZEZXKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:10:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48478 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758951AbZEZXKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:10:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Date: Wed, 27 May 2009 01:10:53 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: nigel@tuxonice.net, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <200905260058.54482.rjw@sisk.pl> <200905270051.35831.oliver@neukum.org>
In-Reply-To: <200905270051.35831.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905270110.54259.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 May 2009, Oliver Neukum wrote:
> Am Dienstag, 26. Mai 2009 00:58:53 schrieb Rafael J. Wysocki:
> > > No, I am afraid it is not. The average user has no clue. Even if that
> > > is not the problem, the user never knows for sure he has encountered
> > > the worst case.
> >
> > OK there, but surely it's better to have a sysfs attribute than a fixed
> > value?
> 
> Maybe I should have been more verbose.
> 
> A tunable setting is a race condition in itself. The right amount depends
> on the drivers loaded and the devices attached and possibly on the status
> of devices. Nothing of this can be determined statically.
> 
> You want hibernation to work even if the user has plugged in a new device.
> You have to calculate that amount in kernel space.

In practice, though, the drivers don't usually tell us in advance how much
memory they are going to need and I believe the only way they could do that
would be by allocating the memory from a hibernation notifier.

So, until the drivers start to use hibernation (and suspend for that matter)
notifiers, we need workarounds.

Best,
Rafael
