Return-Path: <linux-kernel-owner+w=401wt.eu-S1760592AbYAVKVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760592AbYAVKVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 05:21:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756461AbYAVKUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 05:20:55 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:47627 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755774AbYAVKUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 05:20:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mDU0AH/0G6kyYIM67VSqEtBd700Ph/OBGo5tMioRzR8diMSnYE0BJn1yaA4bu9qOeCC7I17Z+RmUZQMVj8gj4qO42Y1qlLkuIsJFRsC3Oxdqby1QrburN77tWmFX8rNxL3k4n3htF8QeJj+P5qHr2Iwuztp3UwT2foLQgA/MOGU=
Message-ID: <38b2ab8a0801220220j250852e4y7b34c806dd4e72f5@mail.gmail.com>
Date: Tue, 22 Jan 2008 11:20:53 +0100
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Vojtech Pavlik" <vojtech@suse.cz>
Subject: Re: Linux and remote control device
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080122101415.GD6323@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0801220001t284c41bdo42b534599249df2a@mail.gmail.com>
	 <20080122081931.GC5591@suse.cz>
	 <38b2ab8a0801220147g15aba253g663a697c80b90397@mail.gmail.com>
	 <20080122101415.GD6323@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 22, 2008 11:14 AM, Vojtech Pavlik <vojtech@suse.cz> wrote:
>
> On Tue, Jan 22, 2008 at 10:47:22AM +0100, Francis Moreau wrote:
> > On Jan 22, 2008 9:19 AM, Vojtech Pavlik <vojtech@suse.cz> wrote:
> > > On Tue, Jan 22, 2008 at 09:01:10AM +0100, Francis Moreau wrote:
> > > > Hello,
> > > >
> > > > I'd like to add support for my Infrared remote control to Linux.
> > > >
> > > > So far I only see LIRCD project that make the kernel support
> > > > such device but I'm not sure if this project is the best choice
> > > > since it's not part of mainline kernels. And there are certainly
> > > > good reasons which I'm not aware of.
> > > >
> > > > Another possibility is to make the remote controle device an input
> > > > device. But I see several flaws:
> > > >
> > > > - The IR receiver on my board can't be use as a transmitter any
> > > > more
> > >
> > > The input subsystem moves events in both directions. It would need some
> > > additional hacking to work with IR transmitters, but it might be
> > > possible.
> > >
> > > > - All scancodes are embedded in the kernel.
> > >
> > > While they reside in the kernel, they can be changed from userspace.
> > >
> > > > Do you think it's still the way to go despite the 2 points raised above ?
> > >
> > > It might be, but I'm not 100% convinced either.
> > >
> >
> > All your answers sound good however.
> >
> > Could you please tell me why you're not sure ?
>
> It would still limit the IR ability to sending/receiving "just"
> keypresses. You may want to send and receive more (arbitrary data) over
> an IR dongle attached to the machine.
>

Don't know about such devices. The device I actually have, an infrared
remote control, seems simple enough to use the input device model. I
have a wheel on it but I think I can make it work too...

Thanks
-- 
Francis
