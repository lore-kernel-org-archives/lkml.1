Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbYACIF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbYACIF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 03:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527AbYACIFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 03:05:15 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:1798 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbYACIFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 03:05:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=glaEamDAHczmxlB15ingQreSVs5KjAyaFJmkLLF5vfDwyRjD9EXUM0+96kfIQCEQmudb70f6TUFtkKdi7ty7kA+QrdP1xAYsjbxOYrZFUMuibNPOwT3D6Mqy4M4jspfmc6AAsz0WkIVmg7oYvK8jLONVuLyO0sdp5j6CGJJ7L0g=
Message-ID: <386072610801030005g7408f333m935c665c82d3412a@mail.gmail.com>
Date: Thu, 3 Jan 2008 16:05:12 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [linux-usb-devel] [PATCH] : Allow embedded developers USB options normally reserved for OTG
Cc: "Robin Getz" <rgetz@blackfin.uclinux.org>,
       linux-usb-devel@lists.sourceforge.net, gregkh@suse.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <200801022336.10355.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801020948.51310.rgetz@blackfin.uclinux.org>
	 <200801021943.38716.david-b@pacbell.net>
	 <386072610801022040ja4919bapa8a0712c1246c3f3@mail.gmail.com>
	 <200801022336.10355.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 3, 2008 3:36 PM, David Brownell <david-b@pacbell.net> wrote:
> On Wednesday 02 January 2008, Bryan Wu wrote:
> > B.T.W, 2 questions about the MUSB driver:
> > 1. What's the plan for mainline merge of the whole MUSB driver? maybe
> > I can cleanup current Blackfin ports to you guys.
>
> It might as well merge in 2.6.25-early.  It'll be easier to integrate
> patches that way.  Including your Blackfin port.  When I asked before,
> nobody hugely objected to "one big patch".
>
>
> > 2. Do you remember the PING issue I reported in OMAP list? How do you
> > think of that?
>
> Yes, something needs to be done.  EHCI might benefit from the same
> kind of patch, to cope with ill-behaved usb thumb drives.
>
>
> > > I have an idea: the USB_NAKLIMIT0 should be set to some value, when we
> > > got NAK timeout interrupt, we can disable PING. When enumerating normal
> > > USB stick, there is no NAK timeout, because PING is efficient for
> > > handshaking. While problem USB stick will generate NAK timeout
> > > interrupt, we disable PING for this kind of USB device enumeration.
>
> That sounds much better than your original patch, which disabled it
> always.  It might even be worth allocating a flag somewhere in the
> usb_device structure to record when ep0 pings seem to misbehave.
>

OK, I will work on it and send out a patch for that fix.

Thanks
-Bryan Wu
