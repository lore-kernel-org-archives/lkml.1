Return-Path: <linux-kernel-owner+w=401wt.eu-S1763783AbXGPXGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763783AbXGPXGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 19:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbXGPXGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 19:06:16 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:35894 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990AbXGPXGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 19:06:15 -0400
Message-ID: <469BF9A8.20306@gmail.com>
Date: Tue, 17 Jul 2007 01:05:12 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Bodo Eggert <7eggert@gmx.de>,
       Matt Mackall <mpm@selenic.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
References: <8FO1e-2jW-35@gated-at.bofh.it> <8GkNo-2Vb-1@gated-at.bofh.it>	 <8GtnN-7TG-23@gated-at.bofh.it> <8GVjY-PL-25@gated-at.bofh.it>	 <E1IA7j1-0000j9-I3@be1.lrz> <469A5D7C.5010904@gmail.com>	 <Pine.LNX.4.58.0707161523500.25779@be1.lrz>	 <469BF104.1040703@gmail.com>	 <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com>	 <20070716235438.1bdd0722@the-village.bc.nu> <2c0942db0707161553u5d55724u82424b3ffbbd79f7@mail.gmail.com>
In-Reply-To: <2c0942db0707161553u5d55724u82424b3ffbbd79f7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2007 12:53 AM, Ray Lee wrote:

> On 7/16/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

>> Any x86-32 path unsafe with 4K stacks is almost certainly unsafe with 8K
>> stacks because the 8K stacks do not have seperate IRQ stack paths, so you
>> have the same space but split. It might be less predictable on 8K stacks
>> but it isn't absent.
> 
> Understood, but isn't that an argument pro interrupt stacks, rather
> than one against 8k? wli has a patch to break out the interrupt stack
> feature from the 4k/8k choice.

Yes but it's also an argument that the 4K stacks don't make the _current_ 
situation without CONFIG_4KSTACKS selected worse and given that you trust 
that current situation, that leaves you without your argument :-)

Rene.


