Return-Path: <linux-kernel-owner+w=401wt.eu-S1758980AbYBXULY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758980AbYBXULY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 15:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757587AbYBXULI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 15:11:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54206 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628AbYBXULG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 15:11:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
Subject: Re: [Bug 10030] Suspend doesn't work when SD card is inserted
Date: Sun, 24 Feb 2008 21:09:47 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
       "Pierre Ossman" <drzeus-mmc@drzeus.cx>,
       "Kernel development list" <linux-kernel@vger.kernel.org>,
       "pm list" <linux-pm@lists.linux-foundation.org>
References: <200802241451.17334.rjw@sisk.pl> <Pine.LNX.4.44L0.0802241409320.11316-100000@netrider.rowland.org> <c4e36d110802241142t9cb340dpc42a2d89166beb7b@mail.gmail.com>
In-Reply-To: <c4e36d110802241142t9cb340dpc42a2d89166beb7b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802242109.48573.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 24 of February 2008, Zdenek Kabelac wrote:
> 2008/2/24, Alan Stern <stern@rowland.harvard.edu>:
> > On Sun, 24 Feb 2008, Rafael J. Wysocki wrote:
> >
> >
> > > > You know, with this new patch we probably don't need
> >  > > device_pm_schedule_removal() any more.
> >  >
> >  > No, we don't.  However, because of that dpm_suspend() and device_power_down()
> >  > need to be changed not to assume that the removed devices will end up on
> >  > dpm_destroy.
> >
> >
> >  with analogous changes to dpm_suspend().
> >
> >  Any more suggestions for updates?
> >
> 
> Is there any current patch I should actually test - it looks there is
> ongoing discussion from the time Rafael has proposed his last patch to
> check by me: http://bugzilla.kernel.org/attachment.cgi?id=14961&action=view
> 
> But I think it's visible the only suspend update will not resolve my
> problems and the problems is deeper in the mmc.

Yes, there are problems in there, but your feedback is needed nevertheless.
 
> So should I still test yesterdays' patch ?

Yes please.  It will be valuable information to us whether it fixes the suspend
issue at least.

Thanks,
Rafael
