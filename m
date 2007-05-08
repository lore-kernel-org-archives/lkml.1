Return-Path: <linux-kernel-owner+w=401wt.eu-S967102AbXEHRsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967102AbXEHRsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 13:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967066AbXEHRsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 13:48:00 -0400
Received: from twin.jikos.cz ([213.151.79.26]:58933 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966887AbXEHRr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 13:47:58 -0400
Date: Tue, 8 May 2007 19:47:45 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Marcel Holtmann <marcel@holtmann.org>
cc: Satyam Sharma <satyam.sharma@gmail.com>, chris@pcburn.com,
       linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net,
       netdev@vger.kernel.org
Subject: Re: Getting make net/built-in.o Error with 2.6.21.1 Build
In-Reply-To: <1178642912.8628.70.camel@aeonflux.holtmann.net>
Message-ID: <Pine.LNX.4.64.0705081944450.16923@twin.jikos.cz>
References: <463FB6B0.3070005@pcburn.com>  <a781481a0705071725i1d802dfejbcdaca4ab0a1ff55@mail.gmail.com>
  <Pine.LNX.4.64.0705081740550.16923@twin.jikos.cz> 
 <a781481a0705080905l609dc925s93357e6eb0d4c318@mail.gmail.com> 
 <Pine.LNX.4.64.0705081815130.16923@twin.jikos.cz> <1178642912.8628.70.camel@aeonflux.holtmann.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, Marcel Holtmann wrote:

> > Marcel - are you aware of any devices currently supported by USB HID 
> > force-feedback code, which have a bluetooth version, please?
> I haven't looked at all details for the PS3 controller, but that might
> be the first one. In theory they can and at some point they will enter
> the market.

You are right, PS3 controller is going to be shipped in both variants. On 
the other hand it is perfectly possible that we will need special 
force-feedback driver for it anyway.

BTW when talking about this - we already have PS3 quirk present in usb hid 
(extra control URB is required to make it operational), probably something 
similar will be needed for BT version too.

> > From: Jiri Kosina <jkosina@suse.cz>
> > [Bluetooth] HIDP - don't initialize force feedback
> > The current implementation of force feedback for HID devices is 
> > USB-transport only and therefore calling hid_ff_init() from hidp code is 
> > not going to work (plus it creates unwanted dependency of hidp on usbhid). 
> > Remove the hid_ff_init() until either the hid-ff is made 
> > transport-independent, or at least support for bluetooth transport is 
> > added.
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
> Under the condition that you remember to put it back once a generic FF
> exists.

Sure. I will take this through my tree then, thanks.

-- 
Jiri Kosina
