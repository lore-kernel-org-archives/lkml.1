Return-Path: <linux-kernel-owner+w=401wt.eu-S1761883AbZAHTzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761883AbZAHTzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 14:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750918AbZAHTzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 14:55:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52953 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146AbZAHTzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 14:55:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [Regression] USB wakeup problem on Toshiba Portege R500
Date: Thu, 8 Jan 2009 20:54:44 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: oliver@neukum.org, stern@rowland.harvard.edu, gregkh@suse.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, pavel@suse.cz,
       torvalds@linux-foundation.org
References: <200901080835.39639.rjw@sisk.pl> <200901081803.49632.rjw@sisk.pl> <200901081955.12021.elendil@planet.nl>
In-Reply-To: <200901081955.12021.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901082054.45051.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 January 2009, Frans Pop wrote:
> Rafael J. Wysocki wrote:
> > On Thursday 08 January 2009, Oliver Neukum wrote:
> >> Am Thursday 08 January 2009 17:36:12 schrieb Rafael J. Wysocki:
> >> You are making a very persuasive argument for reverting it.
> >> But what about laptops that only have a USB keyboard?
> > 
> > Well, up to and including 2.6.28 they needed to echo 'enable' to the USB
> > controllers' /sys/devices/.../power/wakeup files, so if the patch is
> > reverted, they won't be worse off than they were day before
> > yesterday. :-) 
> > 
> > Perhaps we can choose the default depending on whether or not any HID
> > devices are attached to given controller?
> 
> Is "resume on keyboard activity" really all that needed? Both my laptops 
> and my desktop resume fine after pressing the power button.
> 
> Also consider the following cases:
> - laptop has been suspended with external USB mouse connected
>   - mouse is moved (accidentally or because it is in the way of a coffee
>     cup)
>   - mouse cable is removed before putting the laptop in a bag for
>     transport
> - laptop is in docking station with USB mouse/kbd connected to that
>   - again, mouse gets moved for some reason
>   - laptop is undocked while suspended
>   - or the reverse: laptop gets docked

One more case (a real-life example actually):
- There is a USB wireless mouse attached to the box while suspending and the
  mouse is powered off by pressing a button on it.  The mouse's radio receiver
  remains in a USB port on the box.  Now, if the mouse is powered off again,
  the box will resume.  What if that happens accidentally while the box is
  being carried in a backpack?

> IMO it is not desirable that the system gets resumed as a result of any of 
> those actions. I'm not complete sure that it would in all those cases, 
> but have they been considered?
> 
> And in general I've always been in favor of things only happening 
> automagically if I've explicitly asked for that, and not by default.

I have to say I agree.

Thanks,
Rafael
