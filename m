Return-Path: <linux-kernel-owner+w=401wt.eu-S1762670AbXGFHyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762670AbXGFHyW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 03:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755829AbXGFHyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 03:54:15 -0400
Received: from web32606.mail.mud.yahoo.com ([68.142.207.233]:40434 "HELO
	web32606.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754030AbXGFHyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 03:54:14 -0400
X-YMail-OSG: 9HUhH_oVM1kAe0piHQLdBYUK77hwOYti1lAlv4K_S9mB6ViW0I3qt0ZYz4RBmua8Kf5F9iXbeiVpcreI1p.MIOJWrg--
X-RocketYMMF: knobi.rm
Date: Fri, 6 Jul 2007 00:54:13 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Reply-To: spamtrap@knobisoft.de
Subject: Re: Understanding I/O behaviour
To: Jesper Juhl <jesper.juhl@gmail.com>, Robert Hancock <hancockr@shaw.ca>
Cc: knobi@knobisoft.de, linux-kernel@vger.kernel.org
In-Reply-To: <9a8748490707051653q6e1b6bf3g9a3d6edf213867d9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <684951.37870.qm@web32606.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Jesper Juhl <jesper.juhl@gmail.com> wrote:

> On 06/07/07, Robert Hancock <hancockr@shaw.ca> wrote:
> [snip]
> >
> > Try playing with reducing /proc/sys/vm/dirty_ratio and see how that
> > helps. This workload will fill up memory with dirty data very
> quickly,
> > and it seems like system responsiveness often goes down the toilet
> when
> > this happens and the system is going crazy trying to write it all
> out.
> >
> 
> Perhaps trying out a different elevator would also be worthwhile.
> 

 AS seems to be the best one (NOOP and DeadLine seem to be equally OK).
CFQ gives less (about 10-15%) throughput except for the kernel with the
cfs cpu scheduler, where CFQ is on par with the other IO schedulers.

Thanks
Martin

------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de
