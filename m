Return-Path: <linux-kernel-owner+w=401wt.eu-S1753896AbYKWRn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbYKWRn2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 12:43:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbYKWRnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 12:43:17 -0500
Received: from bu3sch.de ([62.75.166.246]:33162 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbYKWRnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 12:43:17 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: BCM4312 Fails when xdm is started
Date: Sun, 23 Nov 2008 18:42:46 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Yuval Hager <yuval@avramzon.net>, bcm43xx-dev@lists.berlios.de,
       LKML <linux-kernel@vger.kernel.org>,
       wireless <linux-wireless@vger.kernel.org>, Peter Stuge <peter@stuge.se>
References: <200811151801.02369.yuval@avramzon.net> <200811231320.30289.mb@bu3sch.de> <492979E4.1070606@lwfinger.net>
In-Reply-To: <492979E4.1070606@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811231842.46775.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 November 2008 16:42:28 Larry Finger wrote:
> Michael Buesch wrote:
> > On Sunday 23 November 2008 12:49:55 Yuval Hager wrote:
> >> [  182.891400] ****** b43: B43_MMIO_MACCTL 0x840A0503
> >> [  182.891409] ****** b43: SSB_TMSLOW 0x20150000
> >> [  258.299027] irq 10: nobody cared (try booting with the "irqpoll" option)
> > 
> > 
> > Does the kernel disable the PCI device, if it ignores the IRQ?
> 
> According to /proc/interrupts that Yuval posted earlier, IRQ 10 is not used.

Can you try booting with kernel parameters "noapic" and "noacpi"
and reproduce?

-- 
Greetings Michael.
