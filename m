Return-Path: <linux-kernel-owner+w=401wt.eu-S935457AbXGZTus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935457AbXGZTus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 15:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765800AbXGZTuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 15:50:39 -0400
Received: from h155.mvista.com ([63.81.120.155]:37056 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765651AbXGZTui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 15:50:38 -0400
Message-ID: <46A8FB86.2010907@ru.mvista.com>
Date: Thu, 26 Jul 2007 23:52:38 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/2] [IDE] Platform IDE driver (was: MMIO IDE driver)
References: <20070725165318.5331.23795.stgit@localhost.localdomain>	<Pine.LNX.4.60.0707252130090.6234@poirot.grange>	<20070725213925.2f25906c@the-village.bc.nu> <Pine.LNX.4.60.0707262136530.6614@poirot.grange>
In-Reply-To: <Pine.LNX.4.60.0707262136530.6614@poirot.grange>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Guennadi Liakhovetski wrote:

>>>driver to using platform-device. I got a reply, that it's not worth it now 
>>>that IDE is slowly becoming obsolete, and the pata_platform serves the 
>>>perpose perfectly well. I found this argument reasonable, I had the same 
>>>doubt, just wanted to double-check. So, why do we now need a new legacy 
>>>(a/drivers/ide/legacy/ide_platform.c) driver when a "modern" driver 
>>>exists?

>>We don't *need* it but some people still want to use old IDE and the
>>author was willing to make it neatly compatible so that anything that
>>works with the pata_platform should be able to use the ide_platform
>>driver and vice versa. For the shorter term that can only be a good thing
>>- arch code doesn't need to care about which driver is used, end users
>>can pick and it doesn't end up adding new ties between code and old IDE.

> Ok, thanks for the explanation Alan. So, there's no technical argument, 
> just "being nice to the users", and add a new driver, which we know we'll 
> have to remove soon, thus having to persuade its users, who by that time 

    Define "soon". :-)

> will get used to it and will not want to invest money into switching to 
> another one...

    Invest into what if the drivers are functionally identical?

> Thanks
> Guennadi

MBR, Sergei
