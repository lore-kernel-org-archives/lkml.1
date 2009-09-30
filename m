Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbZI3Vxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbZI3Vxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 17:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827AbZI3Vxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 17:53:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50333 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114AbZI3Vxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 17:53:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: suspend vs usb and PS/2 ports
Date: Wed, 30 Sep 2009 23:54:55 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: "Linux-kernel" <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <4AC35F86.20405@msgid.tls.msk.ru>
In-Reply-To: <4AC35F86.20405@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909302354.55673.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 September 2009, Michael Tokarev wrote:
> Hello.
> 
> I've several PCs here which are able to wakeup -
> among others - from PS/2 and/or USB keyboard.
> Here for testing I'm using PS/2 keyboard and
> Asus M3A78-EM motherboard.
> 
> When I do poweroff from linux, the keyboard
> stays powered up as it should (according to
> the BIOS settings).  But when I do suspend,
> keyboard is NOT powered anymore, and hence
> the system can't be woken up from it but only
> by using the power button.
> 
> This happens consistently for many kernel
> versions.  To be fair, I don't even know if
> there was any kernel which does not show this
> behaviour: old versions was unable to do
> suspend/resume cycle on this platform at all.
> 
> Any hints for this please?

With USB, I think keyboard wake-up is off by default as it causes some
systems to wake up immediately after suspending.  Alan and Oliver can provide
more info about that.

I don't know about PS/2.

Can you post the contents of /proc/acpi/wakeup from one of these systems,
please?

Best,
Rafael
