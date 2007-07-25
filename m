Return-Path: <linux-kernel-owner+w=401wt.eu-S935066AbXGYSrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935066AbXGYSrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 14:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761260AbXGYSrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 14:47:12 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:43698 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbXGYSrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 14:47:11 -0400
Message-ID: <46A79AA1.3030608@freescale.com>
Date: Wed, 25 Jul 2007 13:46:57 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.7.10) Gecko/20050909 Red Hat/1.7.10-1.1.3.2
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: Vitaly Bordug <vitb@kernel.crashing.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/2] [POWERPC] MPC8349E-mITX: use platform IDE driver
 for CF	interface
References: <20070725165318.5331.23795.stgit@localhost.localdomain> <20070725165326.5331.19920.stgit@localhost.localdomain> <46A78322.3080607@ru.mvista.com> <46A78E3F.1030904@ru.mvista.com> <20070725180145.GA29689@ld0162-tx32.am.freescale.net> <46A7968D.3070707@ru.mvista.com>
In-Reply-To: <46A7968D.3070707@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:
>    I acn undertand your complaint in the context of an OF driver (which 
> we don't have yet) but "mmio-ide" just means nothing to the current 
> driver, and it doesn't convery enough info on the programming interface 
> for the conceivable OF driver, it also does need to know at least 
> "reg-stride" (and maybe "reg-size" in case only 16/32-bit accesses can 
> be used).  Well, if such driver will be written, I/O mapping support 
> will probably be dropped from it, so indeed, calling it mmio-ide.c would 
> make sense.  But that can be added when this driver is done, and for now 

I don't think the details of what Linux code currently exists should 
drive the device tree binding.  That the current patches use 
platform_device glue code is an implementation detail (and one I'd 
rather see go away, in favor of a driver that supports both 
platform_device and of_device).

> I'd really prefer the board name to appear in the "compatible" prop (to 
> which "mmio-ide" can be appended)...

Sure, that's always good...  it was the "instead" that I objected to.

-Scott
