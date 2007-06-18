Return-Path: <linux-kernel-owner+w=401wt.eu-S1762757AbXFRMQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762757AbXFRMQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 08:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761543AbXFRMQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 08:16:33 -0400
Received: from host.infinivid.com ([64.119.179.76]:41110 "EHLO
	host.infinivid.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902AbXFRMQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 08:16:32 -0400
Subject: Re: allocation failed: out of vmalloc space - use vmalloc=<size>
	to increase size.
From: Jon Dufresne <jon.dufresne@infinitevideocorporation.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <466F008D.6060001@zytor.com>
References: <6278d2220706121001r38a1752axba90de1b4e315f75@mail.gmail.com>
	 <466EE115.9030805@zytor.com>
	 <1181676094.8164.26.camel@microwave.infinitevideocorporation.com>
	 <466F008D.6060001@zytor.com>
Content-Type: text/plain
Date: Mon, 18 Jun 2007 08:16:30 -0400
Message-Id: <1182168990.8164.68.camel@microwave.infinitevideocorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, thanks for the help.

Now do I actually need to have the memory mapped in kernel space through
ioremap(), in order to have the memory mapped into user space through
remap_pfn_range()? It seems that remap_pfn_range() only requires a
physical address, not a virtual one.

If this is true then I really don't need to map this in kernel space at
all and only in user space, since it will only be manipulated in user
space.

Thanks,
Jon

On Tue, 2007-06-12 at 13:22 -0700, H. Peter Anvin wrote:
> Jon Dufresne wrote:
> > I wasn't completely honest. It is one bar that has 512 MB, however it is
> > being mapped at 4 128 MB chunks. However, I would like them all mapped
> > at once through the lifetime of the driver.
> > 
> > Is there still no chance?
> 
> 128 MB is still definitely on the heavy side.  Try 64 MB and you might
> be able to get away with it.
> 
> 	-hpa
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

