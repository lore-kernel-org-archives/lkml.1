Return-Path: <linux-kernel-owner+w=401wt.eu-S964786AbXBEWvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964786AbXBEWvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 17:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964830AbXBEWvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 17:51:20 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:46332 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964786AbXBEWvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 17:51:19 -0500
Message-ID: <45C7B4E3.8070802@garzik.org>
Date: Mon, 05 Feb 2007 17:51:15 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Oleg Verych <olecom@flower.upol.cz>
CC: Alan <alan@lxorguk.ukuu.org.uk>, Allen Martin <AMartin@nvidia.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: Nvidia cable detection problems & ACPI (beware, slight off-top)
References: <45C72012.7050605@gmail.com> <20070205132247.6f611e3c@localhost.localdomain> <45C73A3E.6080700@gmail.com> <20070205143439.6962c076@localhost.localdomain> <45C7444F.4070500@gmail.com> <58cb370e0702050709w1b7682dr5dff9e7ce69465a@mail.gmail.com> <DBFABB80F7FD3143A911F9E6CFD477B01EC0DD7D@hqemmail02.nvidia.com> <E1HEB7U-0007IH-FV@flower> <20070205220442.6e13a7b6@localhost.localdomain> <45C7A7D0.407@garzik.org> <20070205224235.GB28048@flower.upol.cz>
In-Reply-To: <20070205224235.GB28048@flower.upol.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Verych wrote:
>> We also need ACPI, where available, because that's the only way to 
>> obtain a BIOS-set hard drive password.
> 
> Plain-text passwords -- i don't actually know, if they are useful at all.
> What if BIOS has admin/user passwords set?
> (kernel: if you have BIOS password, press RESET; if you don't press POWER ;)


It's not a matter of usefulness, but of accessing data.

The password must be provided to the hard drive at the ATA command 
level, otherwise the hard drive will simply refuse to read or write data.

	Jeff


