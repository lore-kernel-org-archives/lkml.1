Return-Path: <linux-kernel-owner+w=401wt.eu-S1758969AbYEENNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969AbYEENNv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 09:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbYEENNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 09:13:39 -0400
Received: from sandeen.net ([209.173.210.139]:25140 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755111AbYEENNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 09:13:39 -0400
Message-ID: <481F0802.4000608@sandeen.net>
Date: Mon, 05 May 2008 08:13:38 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH] i386: Execute stack overflow warning on interrupt stack
 II
References: <20080502091806.GA26062@basil.nowhere.org> <20080502094543.GA11114@basil.nowhere.org> <alpine.LFD.1.10.0805051135530.3318@apollo.tec.linutronix.de> <481EDEC5.10000@firstfloor.org> <alpine.LFD.1.10.0805051434200.3318@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0805051434200.3318@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Mon, 5 May 2008, Andi Kleen wrote:
>> Thomas Gleixner wrote:
>>> On Fri, 2 May 2008, Andi Kleen wrote:
>>>> +static void stack_overflow(void)
>>>> +{
>>>> +	printk("low stack detected by irq handler\n");
>>> Needs a KERN_ERR
>> Just moving code. If there is one added it should be in another patch.
> 
> Err, you are not moving code. The printk is pretty different and
> adding the KERN_xx in the same go is nothing which makes the patch
> harder to understand.
> 
>> Besides if anything it's a KERN_WARN I guess.
> 
> KERN_WARN is fine, even if I consider a stack overflow as an error.

But it hasn't overflowed yet.  It's a warning about being *close* - not
an error.

-Eric
