Return-Path: <linux-kernel-owner+w=401wt.eu-S1765802AbXGKVPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765802AbXGKVPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 17:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbXGKVPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 17:15:20 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:49551 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159AbXGKVPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 17:15:18 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Luca <kronos.it@gmail.com>
Subject: Re: [PATCH] Enable legacy support for serial ports when SERIAL_8250_PNP is disabled
Date: Wed, 11 Jul 2007 15:07:25 -0600
User-Agent: KMail/1.9.6
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20070707233300.GA3267@dreamland.darkstar.lan> <200707091230.01556.bjorn.helgaas@hp.com> <68676e00707111240v28263cc7i13c033c8be1339b9@mail.gmail.com>
In-Reply-To: <68676e00707111240v28263cc7i13c033c8be1339b9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707111507.25412.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 July 2007 01:40:07 pm Luca wrote:
> On 7/9/07, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > On Monday 09 July 2007 11:30:59 am Luca wrote:
> > > On 7/9/07, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > > > If you turn off
> > > > PNP completely, you will have "pnp_platform_devices == 0", and the
> > > > existing code will do what you need.
> > >
> > > Well for me it's a non-issue, I'm able to "work-around" it in many
> > > ways. My point is that a configuration that used to work and is still
> > > valid suddenly doesn't work anymore.
> >
> > You're right about that, and it is a legitimate issue.  But given the
> > fact that (PNP && !SERIAL_8250_PNP) should be relatively unusual, my
> > opinion is that it's not worth extra ifdefs in legacy_serial.c.
> >
> > If you have to use any workarounds like "legacy_serial.force", I think
> > that's a bug, and I'll fix it.
> 
> Ok, I double-checked: the serial port is usable during boot with PNP
> enabled, so no problem with dropping my patch.

Thanks a lot for checking!

Bjorn
