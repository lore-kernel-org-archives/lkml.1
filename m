Return-Path: <linux-kernel-owner+w=401wt.eu-S1759270AbXENIeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759270AbXENIeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 04:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbXENIeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 04:34:11 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:60422 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbXENIeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 04:34:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KvnTS/9EaQWZWrjRrjooIRhd7NEvoT6DNjmP0hsSXuRcREEcnPDDMlYpt7OA7KFdQuhF7ga55bF2OQC/nCUzLXoqf+jqayUUv7vTYCo3M2KpFeKMokT6H5h9pU/dX8Fc+grXnOusEvslwKnvJpfHMnvKj//ScWwcmHEQJKzjgqI=
Message-ID: <5486cca80705140134r318296b8k37ad6f4562b4b535@mail.gmail.com>
Date: Mon, 14 May 2007 10:34:08 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: Linux 2.6.22-rc1
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070514081022.7fcee97f@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
	 <5486cca80705131010h2011487dnc948a3c57ce6decc@mail.gmail.com>
	 <alpine.LFD.0.98.0705131046400.6739@woody.linux-foundation.org>
	 <5486cca80705131150u313eeb43i30bf040e160ac419@mail.gmail.com>
	 <20070514081022.7fcee97f@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/5/14, Jean Delvare <khali@linux-fr.org>:
[cut]
> I am not familiar with the gnome sensors applet. Does it say where it
> is getting the data (driver name, device name...)?

The applet settings show a list of sensors under the libsensors name.
Those are the sensors that work on 2.6.21.1.

However the acpi and i2c section of the two config are
> > identical. I report the only selected options:
> >
> > Power management options (ACPI, APM)  --->
> >   [*] Power Management support
> >   [*]   Software Suspend (Hibernation)
> >   ACPI (Advanced Configuration and Power Interface) Support  --->
> >     [*] ACPI Support
> >     [*]   Sleep States
> >     <M>   Button
> >     <M>   Video
> >     <M>   Fan
> >     <M>   Processor
> >     <M>     Thermal Zone
> >     (0)   Disable ACPI for systems before Jan 1st this year
> >
> > Device Drivers  --->
> >   I2C support  --->
> >     <M>   I2C device interface
> >     I2C Hardware Bus support  --->
> >       <M> VIA VT82C596/82C686/82xx and CX700
>
> You forgot to list the Hardware Monitoring support options.

Sorry. Here it is (they are identical in the two config):

Hardware Monitoring support  --->
  <*> Hardware Monitoring support
  <*> Abit uGuru
  <M> VIA686A
  <*> IBM Hard Drive Active Protection System (hdaps)

But I'm quite sure that the only module used is VIA686A (I'm
rebuilding to confirm).

> > The first column of lsmod list the same modules in both kernels. The
> > diff-ed dmesg is attached.
>
> Please provide the output of lsmod.
>
> If you are using one of the following drivers: lm78, smsc47b397,
> smsc47m1, w83627hf or w83781d, you need lm_sensors >= 2.10.1
> (libsensors.so.3.1.1 or later).
>

I've attached the lsmod for 2.6.22-rc. I'm not using any of the listed
drivers. However the lm-sensors package is version 2.10.1-3 and
libsensors.so.3.1.1 is on my system too (package libsensors3).

Thanks.

> --
> Jean Delvare

    ~ Antonio
