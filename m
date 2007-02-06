Return-Path: <linux-kernel-owner+w=401wt.eu-S933100AbXBFAAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100AbXBFAAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 19:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933102AbXBFAAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 19:00:32 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:46737 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933100AbXBFAAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 19:00:31 -0500
Message-ID: <45C7C509.6090009@garzik.org>
Date: Mon, 05 Feb 2007 19:00:09 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org> <20070205084523.GA21858@elte.hu> <1170682488.29759.795.camel@pmac.infradead.org> <20070205155627.GA8354@elte.hu> <1170692539.29759.856.camel@pmac.infradead.org> <20070205162635.GA755@elte.hu> <20070205163152.GA2464@elte.hu> <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org> <1170710272.29759.894.camel@pmac.infradead.org> <Pine.LNX.4.64.0702051322580.8424@woody.linux-foundation.org> <1170711587.29759.909.camel@pmac.infradead.org> <Pine.LNX.4.64.0702051345380.8424@woody.linux-foundation.org> <1170712393.29759.925.camel@pmac.infradead.org> <Pine.LNX.4.64.0702051409110.8424@woody.linux-foundation.org> <20070205143110.fca62b57.randy.dunlap@oracle.com> <Pine.LNX.4.64.0702051502370.8424@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0702051502370.8424@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> I also feel that a lot of people are "advanced" in one area, but not 
> necessarily in another. The Netfilter example I gave was one such personal 
> gripe of mine. I just feel like I shouldn't need to care! Yeah, I have the 
> knowledge, but I *still* want to be baby-fed with just a simple "anybody 
> can understand it".

It's a good example.  I had a bear of a time with the netfilter kernel 
config on my firewall (w/ IPv6 goodness) box, when the generic netfilter 
stuff landed.  For the first time in a long time, that firewall booted 
into a configuration that wouldn't forward+masq packets properly.


> The same is true of the whole SATA/USB/SCSI thing. I know damn well that 
> the kernel uses the SCSI layer for USB and SATA, yet I feel that the ATA 
> layer does it right, and I just find the USB storage situation to be 
> *offensively* bad in this regard. Why the HELL does it have those big 
> comments and warnings, when it could just damn well enable SCSI support 
> itself?

I think maybe ATA is just lucky.  I allowed myself to get bullied into 
avoiding 'select', even though I feel the same way as you.

ATA should select scsi-disk but doesn't, for example.

And at some point it becomes a matter of taste:  should ATA select 
BLOCK, or depend on BLOCK?  There are IMO good arguments either way.

	Jeff


