Return-Path: <linux-kernel-owner+w=401wt.eu-S1754005AbYKWSI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbYKWSI5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 13:08:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750887AbYKWSIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 13:08:46 -0500
Received: from bu3sch.de ([62.75.166.246]:37864 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbYKWSIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 13:08:45 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Yuval Hager <yuval@avramzon.net>
Subject: Re: BCM4312 Fails when xdm is started
Date: Sun, 23 Nov 2008 19:08:17 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
References: <200811151801.02369.yuval@avramzon.net> <200811231842.46775.mb@bu3sch.de> <200811231955.41722.yuval@avramzon.net>
In-Reply-To: <200811231955.41722.yuval@avramzon.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811231908.17856.mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, LKML <linux-kernel@vger.kernel.org>,
       wireless <linux-wireless@vger.kernel.org>, Peter Stuge <peter@stuge.se>,
       Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 November 2008 18:55:36 Yuval Hager wrote:
> On Sunday 23 November 2008, you wrote:
> > On Sunday 23 November 2008 16:42:28 Larry Finger wrote:
> > > Michael Buesch wrote:
> > > > On Sunday 23 November 2008 12:49:55 Yuval Hager wrote:
> > > >> [  182.891400] ****** b43: B43_MMIO_MACCTL 0x840A0503
> > > >> [  182.891409] ****** b43: SSB_TMSLOW 0x20150000
> > > >> [  258.299027] irq 10: nobody cared (try booting with the "irqpoll"
> > > >> option)
> > > >
> > > > Does the kernel disable the PCI device, if it ignores the IRQ?
> > >
> > > According to /proc/interrupts that Yuval posted earlier, IRQ 10 is not
> > > used.
> >
> > Can you try booting with kernel parameters "noapic" and "noacpi"
> > and reproduce?
> 
> The dump above was generated with "acpi=off noapic nolapic pci=noacpi" boot 
> parameters (see my last email). The /proc/interrupts output was from an 
> earlier occurence, without any of these parameters.
> Did you mean to reproduce and provide logs as well as the content 
> of /proc/interrupts before and after the failure?

No thanks.
Anyway, I cannot really help you with the issue.
I don't think this is a b43 bug, but either a hardware bug or a bug
in some code that controls the PCI bus.

-- 
Greetings Michael.
