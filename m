Return-Path: <linux-kernel-owner+w=401wt.eu-S1761612AbYGOCVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761612AbYGOCVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbYGOCVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:21:41 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:56453 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990AbYGOCVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:21:40 -0400
Message-ID: <487C0A12.9060906@keyaccess.nl>
Date: Tue, 15 Jul 2008 04:23:14 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: david@lang.hm, torvalds@linux-foundation.org, arjan@infradead.org,
       akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
References: <alpine.DEB.1.10.0807141704120.14223@asgard.lang.hm>	<alpine.LFD.1.10.0807141729200.3017@woody.linux-foundation.org>	<alpine.DEB.1.10.0807141750290.14223@asgard.lang.hm> <20080714.185207.203328391.davem@davemloft.net>
In-Reply-To: <20080714.185207.203328391.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15-07-08 03:52, David Miller wrote:

> From: david@lang.hm Date: Mon, 14 Jul 2008 17:51:37 -0700 (PDT)
> 
>> I agree with this, but the proponents of the seperate firmware are
>> listing the fact that the firmware doesn't tie up ram as one of the
>> big reasons for making the change.
> 
> Exactly.
> 
> Otherwise these firmware changes are utterly pointless.

The point of them is legal. Which everyone knows so could perhaps that 
particular dance be done away with?

The current patches allow to

1) load the firmware from userspace
2) load the firmware from the kernel image (vmlinux)

They lack the ability to load the firmware from the module image.

 From a technical standpoint that seems an odd setup. As a driver author 
you'd either be satisfied with loading the firmware from userspace, or 
if for example you feel you're very much tied to your specific firmware, 
you want it to be as close to you as possible -- in the kernel image 
while you yourself are a module makes little sense. You couldn't for 
example just copy the single module around.

That seems a clear technical point to fix but after that, the point is 
legal. At least for existing drivers, this consists of distributions 
worrying about GPL consequences and wanting to seperate out the existing 
firmware blobs.

They do worry -- whatever those worries might be worth -- so there's the 
point. You may feel it not a good point but that's something other than 
no point existing.

I followed along on these flamewars and I'd say to reject these current 
patches on technical grounds until the ability to build the firmware 
into the module exists and merge it after -- even though people might 
feel there's little or no upside to them, I'd say there's little of no 
downside either once that ability is in.

Rene.
