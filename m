Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbXE0Ofo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbXE0Ofo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 10:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbXE0Ofg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 10:35:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:53575 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145AbXE0Off (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 10:35:35 -0400
Subject: Re: udev regression? lsusb silent (no output) since 2.6.22-rc2 at 
	 least
From: Kay Sievers <kay.sievers@vrfy.org>
To: bert hubert <bert.hubert@netherlabs.nl>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
In-Reply-To: <20070527142017.GA24564@outpost.ds9a.nl>
References: <20070526201854.GA20758@outpost.ds9a.nl>
	 <1180233755.3131.4.camel@lov.localdomain>
	 <20070527092546.GA10912@outpost.ds9a.nl>
	 <1180275001.3131.28.camel@lov.localdomain>
	 <20070527142017.GA24564@outpost.ds9a.nl>
Content-Type: text/plain
Date: Sun, 27 May 2007 16:34:37 +0200
Message-Id: <1180276477.3131.43.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/8jHttCZFbMFkuFn4Vr51ybYztO6xCUK4yBei
 2XddebGvwjWhiFq0BCBC7N2pSNODGwBWZ9j6EgA2LCAsIeOi/N
 vH++7Q37+0LJCHeOwVnbcpeSl7e35GR
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-27 at 16:20 +0200, bert hubert wrote:
> > the separate class device. How does that help text sound?
> > 
> >   This option provides backward compatibility for systems where
> >   usbfs is not mounted, and no udev rule like this exists:
> >     SUBSYSTEM=="usb", ACTION=="add", ENV{DEVTYPE}=="usb_device", \
> >       NAME="bus/usb/$env{BUSNUM}/$env{DEVNUM}", MODE="0644"
> 
> I'm mounting my Linus hat now, but the more I think about the
> insta-deprecation of USB_DEVICE_CLASS, and killing lsusb in even a very
> recent distribution release, I think this is an ABI or API change.
> 
> And we hate those.

There is no breakage at all. Nothing has changed regarding ABI/API. It's
just a feature that is configurable now, that was always built-in in
older kernels. That's all, and correctly configured kernels don't break
anything.

> So instead of papering this breakage over with cleverly worded help texts
> that suggest a solution, how about we set USB_DEVICE_CLASS to 'y' by default
> for a few more releases?

Makes sense, yes.

> It would sure save a lot of lkml traffic on 'lsusb broke!'.
> 
> If this is unacceptable, please at least retain the word 'lsusb' somewhere
> in the help text, so people have at least the chance to spot their (current)
> need for USB_DEVICE_CLASS.
> 
> Perhaps:
> 
> "Some distributions need this feature for lsusb to work, unless the udev rule
>  above is configured".

It's libusb access in general and not specific to lsusb.

Kay

