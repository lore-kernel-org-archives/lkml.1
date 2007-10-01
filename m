Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbXJAOPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbXJAOPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 10:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751744AbXJAOO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 10:14:56 -0400
Received: from www.tglx.de ([62.245.132.106]:56438 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736AbXJAOOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 10:14:55 -0400
Date: Mon, 1 Oct 2007 16:14:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Fwd: x86_64 and AMD with C1E
In-Reply-To: <b70f2f960710010550i30ae48bu31f137fe46d70611@mail.gmail.com>
Message-ID: <alpine.LRH.0.999.0710011612001.7353@www.tglx.de>
References: <20071001101532.025d652f@localhost>  <p73r6kf6uwz.fsf@bingen.suse.de>
  <b70f2f960710010546k4658aa1ay466f243ac707c989@mail.gmail.com>
 <b70f2f960710010550i30ae48bu31f137fe46d70611@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007, Mikhail Kshevetskiy wrote:
> No, it boot and work normally. The only thing i bother, is the
> additional 260 timer interrupts per seconds.
> Here is short result:
> 
> c1e enabled:
>   -- power consumption about 23 watts
>   -- there is only C1 power state enabled
>   -- there are about 260 timer interrupts per seconds
> tested with  x86_64(2.6.22, 2.6.23-rc8, 2.6.23-rc8-hrt1 ),
> i386(2.6.21, 2.6.22, 2.6.23-rc5-hrt1)
> 
> c1e disabled:
>   -- power consumption about 27 watts
>   -- there are no any power state enabled (including C1)
>   -- there are no additional 260 timer interrupts per seconds
> tested with 2.6.23-rc6-hrt1/x86_64.
> 
> I want to reduce the power consumption of my notebook. I see the 2 possibility:
>   -- remove 260 additional timer interrupts (c1e enabled case )

There is work in progress on a patch, which allows to utilize the hpet
timers as per cpu timers. This should solve the problem. Be patient.

Thanks,

	tglx
