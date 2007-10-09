Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbXJIGZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbXJIGZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 02:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbXJIGY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 02:24:57 -0400
Received: from www.tglx.de ([62.245.132.106]:42566 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685AbXJIGY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 02:24:56 -0400
Date: Tue, 9 Oct 2007 08:23:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vasily Averin <vvs@sw.ru>
cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, devel@openvz.org
Subject: Re: irq0 stops working
In-Reply-To: <470B1BBF.3020203@sw.ru>
Message-ID: <alpine.LFD.0.9999.0710090822350.25146@localhost.localdomain>
References: <470B1119.8040207@sw.ru> <Pine.LNX.4.64.0710090733410.14524@fbirervta.pbzchgretzou.qr> <470B1BBF.3020203@sw.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Oct 2007, Vasily Averin wrote:

> Jan Engelhardt wrote:
> > On Oct 9 2007 09:26, Vasily Averin wrote:
> >> On one of our servers timer interrupts (i.e irq0) are stops working. As result
> >> any kernel timers do not triggers and tasks waiting some signals from timers
> >> hangs forever.
> > 
> > What kernel.. and tried CONFIG_NO_HZ=n?
> 
> Originally I've noticed this issue on RHEL5 kernels, but then I've reproduced it
> on latest mainstream kernels, in my last attempt it was 2.6.23-rc7.
> 
> Thank you for for your tips about  CONFIG_NO_HZ=n, will try to to it.

You run a 64 bit kernel, where this option is not available yet.

	tglx

