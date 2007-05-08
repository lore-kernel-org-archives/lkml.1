Return-Path: <linux-kernel-owner+w=401wt.eu-S967170AbXEHRu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967170AbXEHRu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 13:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966810AbXEHRu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 13:50:56 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:41189 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966726AbXEHRuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 13:50:55 -0400
Subject: Re: Getting make net/built-in.o Error with 2.6.21.1 Build
From: Marcel Holtmann <marcel@holtmann.org>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Satyam Sharma <satyam.sharma@gmail.com>, chris@pcburn.com,
       linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net,
       netdev@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0705081944450.16923@twin.jikos.cz>
References: <463FB6B0.3070005@pcburn.com>
	 <a781481a0705071725i1d802dfejbcdaca4ab0a1ff55@mail.gmail.com>
	 <Pine.LNX.4.64.0705081740550.16923@twin.jikos.cz>
	 <a781481a0705080905l609dc925s93357e6eb0d4c318@mail.gmail.com>
	 <Pine.LNX.4.64.0705081815130.16923@twin.jikos.cz>
	 <1178642912.8628.70.camel@aeonflux.holtmann.net>
	 <Pine.LNX.4.64.0705081944450.16923@twin.jikos.cz>
Content-Type: text/plain
Date: Tue, 08 May 2007 19:50:10 +0200
Message-Id: <1178646610.8628.78.camel@aeonflux.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

> > > Marcel - are you aware of any devices currently supported by USB HID 
> > > force-feedback code, which have a bluetooth version, please?
> > I haven't looked at all details for the PS3 controller, but that might
> > be the first one. In theory they can and at some point they will enter
> > the market.
> 
> You are right, PS3 controller is going to be shipped in both variants. On 
> the other hand it is perfectly possible that we will need special 
> force-feedback driver for it anyway.
> 
> BTW when talking about this - we already have PS3 quirk present in usb hid 
> (extra control URB is required to make it operational), probably something 
> similar will be needed for BT version too.

I know, but we do that in user space before we hand over the control to
the kernel. It is simpler, because it is on the control channel and that
part is not nicely integrated into the HID subsystem to be used by the
transport layers right now. At least as far as I can tell.

Regards

Marcel


