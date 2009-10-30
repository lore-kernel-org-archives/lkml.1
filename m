Return-Path: <linux-kernel-owner+w=401wt.eu-S1756868AbZJ3Br7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbZJ3Br7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 21:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755081AbZJ3Br7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 21:47:59 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33956 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124AbZJ3Br6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 21:47:58 -0400
Message-ID: <4AEA45CE.2060708@garzik.org>
Date: Thu, 29 Oct 2009 21:47:58 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Robert Hancock <hancockrwd@gmail.com>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] ide: update Kconfig text to mark as deprecated
References: <4AE64FCC.4030102@gmail.com>	<20091029.031344.102288703.davem@davemloft.net>	<51f3faa70910291719kecb5edcp3b8812981b69acb1@mail.gmail.com> <20091030003232.6db3f8b8@lxorguk.ukuu.org.uk>
In-Reply-To: <20091030003232.6db3f8b8@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-14; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2009 08:32 PM, Alan Cox wrote:
> IDE will self correct in time anyway - new hardware doesn't work with it,
> newer embedded devices are also moving away from compact flash, so it'll
> die of its own accord.
>
> As such while things like pmac support in libata will be nice I don't
> think there is any need to go around obsoleting it or pressuring people
> to move stacks.


This has been my general policy...  people will continue moving away 
from IDE over time.  Not much need to do anything but let sleeping dogs lie.

libata definitely needs pmac support, that is the really only big 
missing driver piece, IMO.

On compatibility:  while a compat ATA block device would be nice -- 
having a native Linux block driver for ATA disks has been a longstanding 
"want" since Day One -- a compat block device purely for these 
situations would be quite a bit of work for a tiny-and-shrinking 
userbase.  And that totally ignores an idea of attempting compatibility 
with IDE's ATAPI setup, another huge can-o-worms.

	Jeff



