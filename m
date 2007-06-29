Return-Path: <linux-kernel-owner+w=401wt.eu-S1758533AbXF2IjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533AbXF2IjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 04:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbXF2IjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 04:39:01 -0400
Received: from www.osadl.org ([213.239.205.134]:52173 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752798AbXF2IjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 04:39:00 -0400
From: =?iso-8859-1?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
To: "Midhun Agnihotram" <agnimidhun@gmail.com>
Subject: Re: Fwd: Mounting MMC card
Date: Fri, 29 Jun 2007 10:38:58 +0200
User-Agent: KMail/1.9.5
Cc: jdi@l4x.org, drzeus-mmc@drzeus.cx, linux-kernel@vger.kernel.org
References: <4dde4acb0706261146s5906d8f3vb787d5aecb429116@mail.gmail.com> <200706282210.23770.hjk@linutronix.de> <4dde4acb0706290040p4f90b0b5q630b8e0bd5982908@mail.gmail.com>
In-Reply-To: <4dde4acb0706290040p4f90b0b5q630b8e0bd5982908@mail.gmail.com>
Organization: Linutronix
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706291038.58358.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 29 Juni 2007 09:40 schrieb Midhun Agnihotram:

> 
> >* Is support for the file system on the MMC in your kernel?
> 
>   Yes. There is support for MMC card in my kernel. 

I was talking about the file system on the card. Usually, you've
got vfat on such a card. How about that?

BTW, You mounted proc on /proc and sysfs on /sys, I hope?

> 
>    I have checked the log and it is attached to the end of the mail.
> The log contains debug messages for removing and inserting the MMC
> card. But nothing specific relating to mount. Can you interpret
> anything more from it?

No. You don't have jffs2 on your MMC, do you?

> 
> >Have you checked that your device nodes are correct? Since you use busybox I
> >assume the system is too lightweight to run udev.
> 
>     Yes. I have checked the device nodes. They are fine for MMC. (I
> have made them form what I got on the internet. BTW can anybody tell
> me how can I find the corresponding major and minor number for my
> device driver? This MMC driver is from Microcross. I have put the
> device nodes as 254,0 - which are generic.).

Here's what I have (nodes created by udev):

# ls -l /dev/mmc*
brw-rw----    1 root     root     254,   0 Jun 29 08:41 /dev/mmcblk0
brw-rw----    1 root     root     254,   1 Jun 29 08:41 /dev/mmcblk0p1

> 
> >I run udev on an arm system, it costs you about 200kBytes,
> >and saves you all the trouble with creating device files.
> >Note that you don't need any rules files. If you want to write
> >rules, you can even implement a poor-man's hotplug without HAL.
> >If you can afford 200k, use udev.
> 
>    I have seen the udev page. But I am a bit skeptic about
> implementing it with my kernelas this kernel is from Microcross -
> customized for CSB535FS board. 

As long as it's a reasonable recent kernel (>=2.6.15), it shouldn't
be a problem. 

> I want to try udev only as my last 
> option.

Your choice.

Hans




