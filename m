Return-Path: <linux-kernel-owner+w=401wt.eu-S1759693AbXEMSvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759693AbXEMSvG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 14:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757489AbXEMSu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 14:50:56 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:14926 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757475AbXEMSuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 14:50:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=CJ0rJsw+fMrFo/IhhwyUh/sFDPjvtUzPnDcXjDdvB8wZbz8AMLvWJogfkwphvIyW6eOlicRgfLCnJjVf0DyEhCOW+5/oV3xR9BoWrt+e6qQHHe6Iw74F23FZ54B2nDGVA7OGhmW8juDcKge+nDB62CfSR1HLR+QKlYYXwf8jrOc=
Message-ID: <5486cca80705131150u313eeb43i30bf040e160ac419@mail.gmail.com>
Date: Sun, 13 May 2007 20:50:54 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.22-rc1
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jean Delvare" <khali@linux-fr.org>
In-Reply-To: <alpine.LFD.0.98.0705131046400.6739@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_119142_15286140.1179082254751"
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
	 <5486cca80705131010h2011487dnc948a3c57ce6decc@mail.gmail.com>
	 <alpine.LFD.0.98.0705131046400.6739@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_119142_15286140.1179082254751
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

2007/5/13, Linus Torvalds <torvalds@linux-foundation.org>:
>
>
> On Sun, 13 May 2007, Antonino Ingargiola wrote:
> >
> > On my desktop pc with Debian Etch and 2.6.22-rc1 the gnome panel
> > applet "Sensors Applet" give an error message "No chip detected".
> > Works fine on 2.6.21.1 (it show cpu temperature) with the same config
> > (I've only only done  make oldconfig).
>
> One thing to check is that "make oldconfig" can actually change the
> configuration if things were moved behind a new top-level configuration
> parameter or such. I'm not saying that's the case here, but it's possible
> that things like the i2c changes might have made you inadvertedly changed
> some config option.

I suspected so. However the acpi and i2c section of the two config are
identical. I report the only selected options:

Power management options (ACPI, APM)  --->
  [*] Power Management support
  [*]   Software Suspend (Hibernation)
  ACPI (Advanced Configuration and Power Interface) Support  --->
    [*] ACPI Support
    [*]   Sleep States
    <M>   Button
    <M>   Video
    <M>   Fan
    <M>   Processor
    <M>     Thermal Zone
    (0)   Disable ACPI for systems before Jan 1st this year

Device Drivers  --->
  I2C support  --->
    <M>   I2C device interface
    I2C Hardware Bus support  --->
      <M> VIA VT82C596/82C686/82xx and CX700

> > Is this considered a regression or can be due to userland incompatibilities?
>
> It's a regression, although I'd like to know more about your cases. It's
> just hard to tell what happened: was it a i2c/hwmon driver that got
> broken, or is it some sysfs file that got buggered, or what..
>
> For example, "dmesg" output before and after (preferably as a diff between
> the two), and what modules you had loaded in the working/nonworking case.
>

The first column of lsmod list the same modules in both kernels. The
diff-ed dmesg is attached.

>                         Linus

  ~ Antonio

------=_Part_119142_15286140.1179082254751
Content-Type: application/x-bzip2; 
	name=diff-u-dmesg.2.6.21.1-dmesg.2.6.22-rc1.bz2
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f1nv2km9
Content-Disposition: attachment; filename="diff-u-dmesg.2.6.21.1-dmesg.2.6.22-rc1.bz2"

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
------=_Part_119142_15286140.1179082254751--
