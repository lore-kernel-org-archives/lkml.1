Return-Path: <linux-kernel-owner+w=401wt.eu-S964777AbXBEVze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964777AbXBEVze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 16:55:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964778AbXBEVze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 16:55:34 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:45952 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964777AbXBEVzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 16:55:33 -0500
Message-ID: <45C7A7D0.407@garzik.org>
Date: Mon, 05 Feb 2007 16:55:28 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
CC: Oleg Verych <olecom@flower.upol.cz>, Allen Martin <AMartin@nvidia.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: Nvidia cable detection problems & ACPI (beware, slight off-top)
References: <20070205075836.GG1625@htj.dyndns.org>	<20070205112410.5a3c3182@localhost.localdomain>	<45C72012.7050605@gmail.com>	<20070205132247.6f611e3c@localhost.localdomain>	<45C73A3E.6080700@gmail.com>	<20070205143439.6962c076@localhost.localdomain>	<45C7444F.4070500@gmail.com>	<58cb370e0702050709w1b7682dr5dff9e7ce69465a@mail.gmail.com>	<DBFABB80F7FD3143A911F9E6CFD477B01EC0DD7D@hqemmail02.nvidia.com>	<E1HEB7U-0007IH-FV@flower> <20070205220442.6e13a7b6@localhost.localdomain>
In-Reply-To: <20070205220442.6e13a7b6@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
>> I'm very upset, that hardware nvidia-lego forces system software (and
>> programmers) to know "unfortunately no standard" ways of desinging
>> things... One read-only-for-os, hardware set bit in kind of control
> 
> The hardware doesn't. The BIOS authors do by not setting the cable flags.
> We actually need to use the STM and GTM methods for PC suspend/resume so
> it makes sense to see if they will work out in this case too.


We also need ACPI, where available, because that's the only way to 
obtain a BIOS-set hard drive password.  And BIOS vendors often deliver 
hard drive-specific errata this way, if the problem is serious enough 
(though certainly we would prefer that the OS knows about drive errata, 
when a runtime patch is necessary)

	Jeff


