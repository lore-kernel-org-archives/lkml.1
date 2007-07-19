Return-Path: <linux-kernel-owner+w=401wt.eu-S1761254AbXGSUPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761254AbXGSUPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 16:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754865AbXGSUPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 16:15:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53582 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757956AbXGSUPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:12 -0400
Subject: Re: Slow IRQ handling? (was: Nova-T, cx88-dvb & "cx88_wakeup: 2
	buffers handled (should be 1)")
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hanno Zulla <abos@hanno.de>
Cc: Gerd Hoffmann <kraxel@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4694BF03.5070508@hanno.de>
References: <4693C318.8040105@hanno.de> <46949AFD.5030101@redhat.com>
	 <4694BF03.5070508@hanno.de>
Content-Type: text/plain; charset=utf-8
Date: Thu, 19 Jul 2007 17:13:45 -0300
Message-Id: <1184876025.4049.275.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hanno,

Em Qua, 2007-07-11 às 13:29 +0200, Hanno Zulla escreveu:
> Hi,
> 
> [ please cc me. Thanks. ]
> 
> > I've added the printk some years ago.  I stopped maintaining v4l/dvb
> > bits two years ago, so it's a bit a shot into the dark because I have no
> > idea what has changed recently in the driver.
> 
> Indeed, it appears that this driver has no maintainer right now. (Or the
> maintainer is on holidays.
It is the second :) I was in vacations.

> > Could also be the irq handler for the other device sharing the same irq
> > being very slow.  Any pattern here that it is linked to some specific
> > device sharing the irq?
> 
> No idea, I did not see any pattern here. Also, the problem on my system
> appears with every PCI slot I tried.
> 
> What do you suggest? How can I debug this issue so that you kernel guys
> can look into it?

Debugging this type of trouble is not always easy, since it is
system-specific, and probably not directly related to cx88 driver, since
cx88 drivers work fine on several configurations. 

So, we need more details about your configuration. You may try also to
use the latest vanilla linux kernel (2.6.22.1). Maybe this might be an
issue already handled.

You can do a "cat /proc/interrupts". This will help to identify the
shared interrupts and if the processors are balancing the IRQ handling. 

There are some tutorials that may help seeking for a bug:
Documentation/BUG-HUNTING

Also, the file /REPORTING-BUGS, at the main tree contains some
orientations on what kind of information can be retrieved for you to
report a bug.

This can also help you to force the handling of an IRQ to an specific
CPU:
Documentation/IRQ-affinity.txt                                                                          

-- 
Cheers,
Mauro

