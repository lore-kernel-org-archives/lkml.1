Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbXENMOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbXENMOF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 08:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbXENMNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 08:13:55 -0400
Received: from smtp-101-monday.noc.nerim.net ([62.4.17.101]:4986 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752004AbXENMNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 08:13:54 -0400
Date: Mon, 14 May 2007 14:14:37 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Antonino Ingargiola" <tritemio@gmail.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc1
Message-ID: <20070514141437.631fcfd1@hyperion.delvare>
In-Reply-To: <5486cca80705140134r318296b8k37ad6f4562b4b535@mail.gmail.com>
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
	<5486cca80705131010h2011487dnc948a3c57ce6decc@mail.gmail.com>
	<alpine.LFD.0.98.0705131046400.6739@woody.linux-foundation.org>
	<5486cca80705131150u313eeb43i30bf040e160ac419@mail.gmail.com>
	<20070514081022.7fcee97f@hyperion.delvare>
	<5486cca80705140134r318296b8k37ad6f4562b4b535@mail.gmail.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Antonino,

On Mon, 14 May 2007 10:34:08 +0200, Antonino Ingargiola wrote:
> 2007/5/14, Jean Delvare <khali@linux-fr.org>:
> [cut]
> > I am not familiar with the gnome sensors applet. Does it say where it
> > is getting the data (driver name, device name...)?
> 
> The applet settings show a list of sensors under the libsensors name.
> Those are the sensors that work on 2.6.21.1.
> 
> However the acpi and i2c section of the two config are
> > > identical. I report the only selected options:
> > >
> > > Power management options (ACPI, APM)  --->
> > >   [*] Power Management support
> > >   [*]   Software Suspend (Hibernation)
> > >   ACPI (Advanced Configuration and Power Interface) Support  --->
> > >     [*] ACPI Support
> > >     [*]   Sleep States
> > >     <M>   Button
> > >     <M>   Video
> > >     <M>   Fan
> > >     <M>   Processor
> > >     <M>     Thermal Zone
> > >     (0)   Disable ACPI for systems before Jan 1st this year
> > >
> > > Device Drivers  --->
> > >   I2C support  --->
> > >     <M>   I2C device interface
> > >     I2C Hardware Bus support  --->
> > >       <M> VIA VT82C596/82C686/82xx and CX700
> >
> > You forgot to list the Hardware Monitoring support options.
> 
> Sorry. Here it is (they are identical in the two config):
> 
> Hardware Monitoring support  --->
>   <*> Hardware Monitoring support
>   <*> Abit uGuru
>   <M> VIA686A
>   <*> IBM Hard Drive Active Protection System (hdaps)
> 
> But I'm quite sure that the only module used is VIA686A (I'm
> rebuilding to confirm).

This is a rather bad idea to build the abituguru and hdaps drivers into
your kernel if you don't have these devices. Especially abituguru, as
it does arbitrary port probing.

> > > The first column of lsmod list the same modules in both kernels. The
> > > diff-ed dmesg is attached.
> >
> > Please provide the output of lsmod.
> >
> > If you are using one of the following drivers: lm78, smsc47b397,
> > smsc47m1, w83627hf or w83781d, you need lm_sensors >= 2.10.1
> > (libsensors.so.3.1.1 or later).
> 
> I've attached the lsmod for 2.6.22-rc.

You didn't.

> I'm not using any of the listed drivers.

How strange, why are they loaded then?

> However the lm-sensors package is version 2.10.1-3 and
> libsensors.so.3.1.1 is on my system too (package libsensors3).

Can you please share the output of "sensors" under both kernels 2.6.21.1
and 2.6.22-rc1.

I would also be interested in a diff of /proc/ioports between 2.6.21.1
and 2.6.22-rc1.

-- 
Jean Delvare
