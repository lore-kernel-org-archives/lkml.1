Return-Path: <linux-kernel-owner+w=401wt.eu-S1755158AbYFAQR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbYFAQR3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 12:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbYFAQRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 12:17:18 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:60236 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbYFAQRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 12:17:17 -0400
Message-ID: <4842CC50.4030406@keyaccess.nl>
Date: Sun, 01 Jun 2008 18:20:32 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Avuton Olrich <avuton@gmail.com>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Rene Herman <rene.herman@gmail.com>,
       Len Brown <len.brown@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 53052feb6 (PNP: remove pnp_mem_flags() as an lvalue) breaks my
 ALSA intel8x0 sound card regression
References: <3aa654a40806010742r1d61caa2j681882145533b56a@mail.gmail.com>
In-Reply-To: <3aa654a40806010742r1d61caa2j681882145533b56a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -0.8 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01-06-08 16:42, Avuton Olrich wrote:

> My intel8x0 card stops working due to a regression; bisection and
> information below.
> 
> May have relationship to this thread
> http://groups.google.com/group/linux.kernel/browse_thread/thread/d5857287a36e71af/d7ae0a1490b7d142?lnk=st
> 
> http://avuton.googlepages.com/intel8x0-config.gz
> http://avuton.googlepages.com/intel8x0-cpuinfo
> http://avuton.googlepages.com/intel8x0-dmesg

This dmesg seems to be 6-byte file consisting of "dmesg\n" ...

> http://avuton.googlepages.com/intel8x0-ioports
> http://avuton.googlepages.com/intel8x0-lspci-vvv
> http://avuton.googlepages.com/intel8x0-modules
> http://avuton.googlepages.com/intel8x0-ver-linux
> http://avuton.googlepages.com/intel8x0-version
> 
> commit 53052feb6ddd05cb2b5c6e89fb489bf83bbb6803
> Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Date:   Mon Apr 28 16:34:15 2008 -0600
> 
>     PNP: remove pnp_mem_flags() as an lvalue
> 
>     A future change will change pnp_mem_flags() from a "#define that
>     simplifies to an lvalue" to "an inline function that returns the
>     flags value."
> 
>     Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
>     Acked-By: Rene Herman <rene.herman@gmail.com>
>     Signed-off-by: Len Brown <len.brown@intel.com>
> 

I'm probably just really blind but I don't see how that specific commit 
may have made any difference. It _is_ in the exact spot which would fix 
that overlap problem of yours but this should be an identity change as 
far as fuctionality goes. Are you _really_ sure it's this one?

(Is this racing with anything?)

Rene.
