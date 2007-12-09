Return-Path: <linux-kernel-owner+w=401wt.eu-S1753995AbXLICWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbXLICWp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 21:22:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbXLICWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 21:22:37 -0500
Received: from tomts29.bellnexxia.net ([209.226.175.103]:40556 "EHLO
	tomts29-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752144AbXLICWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 21:22:36 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAFPgWkdFn+Sr/2dsb2JhbACmAA
Date: Sat, 8 Dec 2007 21:22:34 -0500
From: Mike Houston <mikeserv@bmts.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org, mhoffman@lightlink.com,
       lm-sensors@lm-sensors.org
Subject: Re: 2.6.24-rc4 hwmon it87 probe fails
Message-Id: <20071208212234.e00b74cd.mikeserv@bmts.com>
In-Reply-To: <20071209000554.GF20441@stusta.de>
References: <20071204215154.7f26285e.mikeserv@bmts.com>
	<20071209000554.GF20441@stusta.de>
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.10.14; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Dec 2007 01:05:54 +0100
Adrian Bunk <bunk@stusta.de> wrote:

> On Tue, Dec 04, 2007 at 09:51:54PM -0500, Mike Houston wrote:
> > I finally got around to testing Linux 2.6.24 (2.6.24-rc4) and
> > found that the it87 driver fails to probe and consequently, my
> > sensors no longer work. This was fine with Linux 2.6.23.8 (the
> > last kernel I was using)
> > 
> > The necessary modules load, but:
> > 
> > it87: Found IT8718F chip at 0x290, revision 2
> > it87: in3 is VCC (+5V)
> > it87 it87.656: Failed to request region 0x290-0x297
> > it87: probe of it87.656 failed with error -16
> > 
> > Coretemp still works.
> > 
> > It appears it has something to do with the ioport range being
> > reserved for some reason:
> > 
> > system 00:01: ioport range 0x290-0x29f has been reserved

> 
> Thanks for your report.
> 
> Please also provide:
> - dmesg from 2.6.23.8
> - The output of "cat /proc/ioports" for both kernels

Thanks Adrian, here is the information you have requested, for
both kernels (I have 2.6.23.9 now though where it87 still works)

Linux 2.6.23.9:
http://www.mikeserv.com/temp/proc_ioports-2.6.23.9.txt
http://www.mikeserv.com/temp/dmesg-2.6.23.9.txt
http://www.mikeserv.com/temp/config-2.6.23.9.txt

Linux 2.6.24-rc4:
http://www.mikeserv.com/temp/proc_ioports-2.6.24-rc4.txt
http://www.mikeserv.com/temp/dmesg-2.6.24-rc4.txt
http://www.mikeserv.com/temp/config-2.6.24-rc4.txt

Mike Houston
