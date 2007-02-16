Return-Path: <linux-kernel-owner+w=401wt.eu-S932982AbXBPHLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982AbXBPHLQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 02:11:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932980AbXBPHLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 02:11:16 -0500
Received: from mail.trixing.net ([87.230.125.58]:43822 "EHLO mail.trixing.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932977AbXBPHLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 02:11:15 -0500
Message-ID: <45D558D6.3050303@l4x.org>
Date: Fri, 16 Feb 2007 08:10:14 +0100
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8) Gecko/20060228 Thunderbird/1.5 Mnenhy/0.6.0.104
MIME-Version: 1.0
To: Mattia Dongili <malattia@linux.it>
CC: Pavel Machek <pavel@ucw.cz>, stelian@popies.net,
       linux-acpi@vger.kernel.org, linux-pm@osdl.org, adaplas@pol.net,
       dawes@xfree86.org, Linux kernel <linux-kernel@vger.kernel.org>
References: <45D43489.3060409@l4x.org> <20070215103639.GB27338@elf.ucw.cz> <37556.85.47.20.193.1171540572.squirrel@picard.linux.it>
In-Reply-To: <37556.85.47.20.193.1171540572.squirrel@picard.linux.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.3
X-SA-Exim-Mail-From: jdi@l4x.org
Subject: Re: [linux-pm] Suspend to RAM, Sony Vaio PCG-SRX51P, lcd stays off
X-SA-Exim-Version: 4.2.1 (built Mon, 27 Mar 2006 14:12:04 +0200)
X-SA-Exim-Scanned: Yes (on mail.trixing.net)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mattia Dongili wrote:
> On Thu, February 15, 2007 11:36 am, Pavel Machek said:

>>>     sys_vendor   = "Sony Corporation    "
>>>     sys_product  = "PCG-SRX51P(DE)      "
>>>     sys_version  = "01                  "
>>>     bios_version = "R0232U2"
>>>

> (unrelated to your suspend problems) does the sony-laptop (formerly
> sony_acpi) module helps controlling brightness?
> (should appear soon or you can eventually grab it from the linux-acpi tree)

No, I use the sonypi driver. But I can test the sony-laptop one as
soon as it is in -mm again if it would be of any help.

>>> Latest kernel I tested is 2.6.20-git11 from today.
> 
> I read reports of successful suspends on that laptop, eg:
> http://freenet-homepage.de/obauer/index.html

Ok, now I feel totally dumb. 's2ram -s -f' actually works iff you disable
fb support completely in the kernel. It works even from X. Don't know how
many combinations I tried but that one somehow slipped through. Anyway
thanks for your help. So could this machine be added to the s2ram
database?

Thanks,

Jan
