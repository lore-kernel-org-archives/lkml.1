Return-Path: <linux-kernel-owner+w=401wt.eu-S1757776AbYFPVkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776AbYFPVkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 17:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754378AbYFPVkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 17:40:03 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54791 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250AbYFPVkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 17:40:01 -0400
Message-ID: <4856DDAA.1080707@garzik.org>
Date: Mon, 16 Jun 2008 17:39:54 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       jaswinder@infradead.org
Subject: Re: [PATCH] ip2: use request_firmware()
References: <1213609751.26255.673.camel@pmac.infradead.org>	<20080616115950.41bc65aa@lxorguk.ukuu.org.uk>	<4856C6C8.6060506@garzik.org>	<4856C795.2050007@garzik.org>	<20080616205820.1fe298d7@lxorguk.ukuu.org.uk>	<4856CB61.6030202@garzik.org> <20080616212111.406f9c96@lxorguk.ukuu.org.uk>
In-Reply-To: <20080616212111.406f9c96@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Extracting the firmware:  good
>>
>> Scattering a /single/ driver across multiple directories in the kernel 
>> tree:  bad
> 
> I'd equally argue that putting all the firmware in one place is more
> logical than smearing it around the tree.

Logical for whom?  Drivers have always been self-contained... until now.

This separation certainly does not make things _easier_ for users, our 
reason for existence.  This separation certainly does not make it easier 
to drop in a driver with a firmware, i.e. not easier on driver 
developers.  It is one more PITA detail when copying a driver from one 
kernel to another, or shipping the driver out of tree.

There are good reasons why the Makefile rules, Kconfig rules, C source 
code and headers for a driver all live together...  moving the firmware 
elsewhere is strangely, given that a driver simply /does not work/ 
without the firmware.

I like the goal, but see little effort in the area of "make this 
transition painless for users."

	Jeff



