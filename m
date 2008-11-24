Return-Path: <linux-kernel-owner+w=401wt.eu-S1752909AbYKXSTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbYKXSTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 13:19:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbYKXST2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 13:19:28 -0500
Received: from rtr.ca ([76.10.145.34]:48781 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbYKXST1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 13:19:27 -0500
Message-ID: <492AF06A.8020004@rtr.ca>
Date: Mon, 24 Nov 2008 13:20:26 -0500
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tejun Heo <tj@kernel.org>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: 2.6.27.6 question: ata_sff_hsm_move: ata15 (why always ata15)?
References: <alpine.DEB.1.10.0811141850590.6217@p34.internal.lan>	<491E4092.5030804@shaw.ca>	<20081115103424.34f01370@lxorguk.ukuu.org.uk>	<491FBA29.3000803@kernel.org> <20081116112511.3913123a@lxorguk.ukuu.org.uk>
In-Reply-To: <20081116112511.3913123a@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Sun, 16 Nov 2008 15:14:01 +0900
> Tejun Heo <tj@kernel.org> wrote:
> 
>> Alan Cox wrote:
>>> On Fri, 14 Nov 2008 21:22:58 -0600
>>> Robert Hancock <hancockr@shaw.ca> wrote:
>>>
>>>> Justin Piszcz wrote:
>>>>> I am trying to find out what the root cause of this error/problem is:
>>>>> https://bugzilla.redhat.com/show_bug.cgi?id=462425
>>>> The problem is that people assume that timeouts with DRDY like that bug 
>>>> refers to must be the same problem when it is often not
>>> The first stopping point is to apply the DRQ drain patch I sent to the
>>> list some time ago and is hopefully lined up for 2.6.29. After that point
>>> you can begin to look at the remaining cases, until then its hardly worth
>>> it.
>> Is it really?  For many SATA controllers, DRQ draining isn't really
>> necessary.  PATA might be a completely different story tho.
> 
> It seems to be needed for various devices and some controllers. Given we
> don't know which it seems to be the sensible starting point for almost any
> failure involving a DRQ being left on. It won't fix them all but it is
> the one case that can easily be eliminated.
..

Well ata_piix for starters.  Verified here by me.

Cheers
