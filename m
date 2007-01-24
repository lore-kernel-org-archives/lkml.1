Return-Path: <linux-kernel-owner+w=401wt.eu-S1752009AbXAXQlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbXAXQlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 11:41:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbXAXQlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 11:41:08 -0500
Received: from mother.pmc-sierra.com ([216.241.224.12]:54847 "HELO
	mother.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752012AbXAXQlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 11:41:06 -0500
Message-ID: <45B78C19.4030408@pmc-sierra.com>
From: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: linux-mips@linux-mips.org, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial driver PMC MSP71xx, kernel linux-mips.git mast
	 er
Date: Wed, 24 Jan 2007 08:40:57 -0800
MIME-Version: 1.0
X-Mailer: Internet Mail Service (5.5.2657.72)
x-originalarrivaltime: 24 Jan 2007 16:40:57.0674 (UTC) FILETIME=[6C5A0AA0:01C73FD6]
user-agent: Thunderbird 1.5.0.9 (X11/20061206)
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Sergei Shtylyov wrote:
> Hello, I wrote:
> 
>  >>>> Here is a serial driver patch for the PMC-Sierra MSP71xx device.
> 
>  >>>> There are three different fixes:
>  >>>> 1. Fix for THRE errata
>  >>>> 2. Fix for Busy Detect on LCR write
>  >>>> 3. Workaround for interrupt/data concurrency issue
> 
>  >>>> The first fix is handled cleanly using a UART_BUG_* flag.
> 
>  >>>    Hm, I wouldn't call it clean...
> 
>  >> Relative to the other two. Any recommended improvements on this one?
> 
>  >    I already told: runtime check.
> 
>     BTW, I've just came accross 2 patches in the -mm tree related to the
> transmitter bug:
> 
> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc4/2.6.20-rc4-mm1/broken-out/8250-make-probing-for-txen-bug-a-config-option.patch

Thanks. The first of these is not at all what we are seeing. However I guess
there could be a remote chance it's triggering our THRE errata as it did for
the pnx4008 boards.

> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc4/2.6.20-rc4-mm1/broken-out/8250-uart-backup-timer.patch

This second patch failure description is identical to what we are seeing without
the THRE work-around. This must be the timer patch Alan mentioned but it's not
in the linux.git at l-m.o.

Could you please explain what you mean by and where I can find the "-mm tree"?

Marc
