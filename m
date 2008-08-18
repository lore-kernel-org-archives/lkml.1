Return-Path: <linux-kernel-owner+w=401wt.eu-S1753020AbYHRVZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbYHRVZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 17:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798AbYHRVZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 17:25:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34597 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbYHRVZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 17:25:19 -0400
Message-ID: <48A9E899.8000303@zytor.com>
Date: Mon, 18 Aug 2008 14:24:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH] pci: change msi-x vector to 32bit
References: <200808160326.m7G3QR1G012726@terminus.zytor.com>	<86802c440808152342m772d5eabs59a9c93ffe4cf557@mail.gmail.com>	<1218898238.3940.6.camel@localhost.localdomain>	<20080816163945.74d487e9@lxorguk.ukuu.org.uk>	<1218903209.3940.14.camel@localhost.localdomain>	<86802c440808161156rf48f23ai9d77ce3cab36f02a@mail.gmail.com>	<1218918341.3940.49.camel@localhost.localdomain>	<86802c440808161334q75a7d019ofade0b6cabf3f74d@mail.gmail.com>	<1218919547.3940.57.camel@localhost.localdomain>	<86802c440808161517y1eaa5a4eo817b8a1bf75945be@mail.gmail.com>	<1218928162.3940.62.camel@localhost.localdomain> <m14p5i2iwx.fsf@frodo.ebiederm.org>
In-Reply-To: <m14p5i2iwx.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> I believe assign_irq_vector on x86_64 and soon on x86_32 does this already.
> 
> The number that was being changed was the irq number of for the
> msi-x ``vectors'' from some random free irq number to roughly
> bus(8 bits):device+function(8 bits):msix-vector(12 bits) so that we
> could have a stable irq number for msi irqs.
> 
> Once pci domain is considered it is hard to claim we have enough bits.
> I expect we need at least pci domains to have one per NUMA node, in
> the general case.
> 
[...]
> 
> So once we have all of that.  It becomes possible to look at assigning a static
> irq number to each pci (bus:device:function:msi-x vector) pair so the system
> is more reproducible.
> 

Domain, again?

	-hpa
