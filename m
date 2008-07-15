Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbYGOO4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbYGOO4y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 10:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbYGOO4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 10:56:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56398 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751863AbYGOO4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 10:56:45 -0400
Date: Tue, 15 Jul 2008 07:55:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Willy Tarreau <w@1wt.eu>
cc: David Miller <davem@davemloft.net>, jeff@garzik.org, arjan@infradead.org,
       akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <20080715045848.GG1369@1wt.eu>
Message-ID: <alpine.LFD.1.10.0807150747540.3017@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org> <487C09EB.1050903@garzik.org> <alpine.LFD.1.10.0807141928540.3017@woody.linux-foundation.org> <20080714.194032.117461306.davem@davemloft.net> <alpine.LFD.1.10.0807141947540.3017@woody.linux-foundation.org>
 <20080715045848.GG1369@1wt.eu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Willy Tarreau wrote:
> > 
> > But once you can load a module, you can load the firmware. You just have 
> > to _remember_ to move it along with the module.
> 
> In order to transfer it, right now you feed it through a working device.
> When that device itself requires firmware to work, you will suddenly
> discover that it becomes harder and harder to get any communication device
> to work on your target system.

Willy, stop this blathering.

I suspect I will have to just delete this thread unread because it's so 
full of total crap.

This whole "working device" argument is total bullshit.

If the driver was a module before, it needed a module load to become 
working. If you could load the module, you could load the firmware. Thus 
the transfer is non-issue.

And if the driver was built-in, you can still build in the firmware.

And by proof of induction - your "now you feed it through a working 
device" - this also holds for that "a working device" driver. The device 
you load the module off has exactly the same rules: you can build in the 
firmware.

So it didn't get any harder at all. Except for the fact that you need to 
remember to install the firmware. 

Which is just about the same thing as asking people to remember to do 
"make modules_install" to get a working system. Yes, if you have a driver 
as a module, you need to install that module for the device to work. Yes, 
it's definitely "harder", but seriously..

			Linus
