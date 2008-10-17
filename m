Return-Path: <linux-kernel-owner+w=401wt.eu-S1757237AbYJQT2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237AbYJQT2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 15:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbYJQT1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 15:27:53 -0400
Received: from pih-relay08.plus.net ([212.159.14.20]:52014 "EHLO
	pih-relay08.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965AbYJQT1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 15:27:52 -0400
X-Greylist: delayed 1814 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Oct 2008 15:27:52 EDT
Message-ID: <48F8E019.20600@mimc.co.uk>
Date: Fri, 17 Oct 2008 19:57:29 +0100
From: Mark Jackson <mpfj@mimc.co.uk>
Organization: Mercury IMC Ltd
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: Alessandro Zummo <alessandro.zummo@towertech.it>,
       rtc-linux@googlegroups.com, lkml <linux-kernel@vger.kernel.org>,
       spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH] Add Dallas DS1390 RTC chip
References: <48F452BE.2030901@mimc.co.uk> <20081014101703.1ded0259@i1501.lan.towertech.it> <48F8467C.5010902@mimc.co.uk> <200810170829.06699.david-b@pacbell.net>
In-Reply-To: <200810170829.06699.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: eb6151a6c486075017e7a9bfe0914a4a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> On Friday 17 October 2008, Mark Jackson wrote:
>>>> +    /* Can tx_buf and rx_buf be equal? The doc in spi.h is not sure... */
>>>> +    xfer.tx_buf = chip->tx_buf;
>>>> +    xfer.rx_buf = chip->rx_buf;
>>>  you use the same buffer a few functions below. either
>>>  one way or the other. please investigate with the spi subsystem maintainer.
>> David,
>>
>> Just to double check (as per Alessandro's suggestion), is this okay use of the 
>> spi buffers ?
> 
> Yes.  That comment deserves to be updated.
> 
> SPI does bi-directional I/O, and the underlying controller
> should be able to just replace the contents of a buffer
> with a spi_transfer that uses the same rx and tx buffers.

Excellent.  Thanks for the confirmation.

Regards
Mark
