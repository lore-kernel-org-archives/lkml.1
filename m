Return-Path: <linux-kernel-owner+w=401wt.eu-S936735AbXGZUOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936735AbXGZUOb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 16:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935651AbXGZUOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 16:14:01 -0400
Received: from mail.gmx.net ([213.165.64.20]:55695 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934726AbXGZUN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 16:13:59 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/Unb5/6DHUeYMLIfmyUky0Z0p3/zS/Hv9CjWcm3G
	T8Bzd3VIDeWQZs
Date: Thu, 26 Jul 2007 22:13:57 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/2] [IDE] Platform IDE driver (was: MMIO IDE driver)
In-Reply-To: <46A8FB86.2010907@ru.mvista.com>
Message-ID: <Pine.LNX.4.60.0707262156250.6614@poirot.grange>
References: <20070725165318.5331.23795.stgit@localhost.localdomain>
 <Pine.LNX.4.60.0707252130090.6234@poirot.grange> <20070725213925.2f25906c@the-village.bc.nu>
 <Pine.LNX.4.60.0707262136530.6614@poirot.grange> <46A8FB86.2010907@ru.mvista.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007, Sergei Shtylyov wrote:

> Guennadi Liakhovetski wrote:
> 
> > Ok, thanks for the explanation Alan. So, there's no technical argument, 
> > just "being nice to the users", and add a new driver, which we know we'll 
> > have to remove soon, thus having to persuade its users, who by that time 
> 
>     Define "soon". :-)

"Soon" in this case means, we NOW have a replacement driver and we aim at 
deprecating the IDE driver in its favour.

> > will get used to it and will not want to invest money into switching to 
> > another one...
> 
>     Invest into what if the drivers are functionally identical?

For example, into porting user space (replace hdx with sdx). And even 
switching to a "functionally identical" driver requires a new complete 
testing cycle... No, I won't be in that situation, so, it's not my money 
I'm worrying about. But I know there are companies for whom releasing a 
new version of /etc/fstab is a considerable expense... Not that I cared 
about them anyway.

Thanks
Guennadi
---
Guennadi Liakhovetski
