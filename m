Return-Path: <linux-kernel-owner+w=401wt.eu-S933740AbZFLKZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933740AbZFLKZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759622AbZFLKZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:25:22 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:53482 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbZFLKZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:25:21 -0400
Message-ID: <4A322D08.2020807@mnementh.co.uk>
Date: Fri, 12 Jun 2009 11:25:12 +0100
From: Ian Molton <ian@mnementh.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Brian Swetland <swetland@google.com>
CC: Nicolas Pitre <nico@cam.org>, Ryan Mallon <ryan@bluewatersys.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Tony Lindgren <tony@atomide.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Miller <davem@davemloft.net>, pavel@ucw.cz,
       lkml <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk, san@android.com,
       rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
References: <20090611111821.GK795@n2100.arm.linux.org.uk>	<20090611132134.GA11199@atomide.com>	<20090611133736.GP795@n2100.arm.linux.org.uk>	<20090611140038.GB11199@atomide.com>	<20090611140624.GS795@n2100.arm.linux.org.uk>	<alpine.LFD.2.00.0906111314510.31536@xanadu.home>	<4A3175AC.9070100@bluewatersys.com>	<alpine.LFD.2.00.0906112105220.31536@xanadu.home>	<4A31AECA.6070303@bluewatersys.com>	<alpine.LFD.2.00.0906112138090.31536@xanadu.home> <a55d774e0906111916y2f49e5a9q362e12b52fb5414a@mail.gmail.com>
In-Reply-To: <a55d774e0906111916y2f49e5a9q362e12b52fb5414a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Swetland wrote:
>
> - would having some ifdefs around code using wakelock support be
> acceptable for the time being?  The wakelock/suspendblock review does
> seem to be making progress on linux-pm if not super quickly, and I'd
> rather maintain some ifdefs than maintain two different versions of
> drivers while it's getting sorted out.

Personally, I'd say no.

Use git - create a version with them dropped and then you can create a 
wakelock-dev branch on top of that with your new stuff in, which can be 
rebased should the underlying branch move on (or get merged with mainline).

Its a problem that wouldnt exist if the original drivers had been 
submitted long ago...
