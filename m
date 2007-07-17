Return-Path: <linux-kernel-owner+w=401wt.eu-S934041AbXGQQxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934041AbXGQQxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 12:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755542AbXGQQxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 12:53:30 -0400
Received: from smtpq3.tilbu1.nb.home.nl ([213.51.146.202]:37237 "EHLO
	smtpq3.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600AbXGQQx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 12:53:29 -0400
Message-ID: <469CF3C6.5070907@gmail.com>
Date: Tue, 17 Jul 2007 18:52:22 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Shawn Bohrer <shawn.bohrer@gmail.com>
CC: Ray Lee <ray-lk@madrabbit.org>, Bodo Eggert <7eggert@gmx.de>,
       Matt Mackall <mpm@selenic.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
References: <E1IA7j1-0000j9-I3@be1.lrz> <469A5D7C.5010904@gmail.com> <Pine.LNX.4.58.0707161523500.25779@be1.lrz> <469BF104.1040703@gmail.com> <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com> <469BF768.6040200@gmail.com> <2c0942db0707161613lff9c07bpcf002b9139163a86@mail.gmail.com> <469BFDA7.1040204@gmail.com> <2c0942db0707161640h3c3afd7avecd7b3c61c4e7df1@mail.gmail.com> <469C1409.9010305@gmail.com> <20070717161454.GB21538@mediacenter.austin.rr.com>
In-Reply-To: <20070717161454.GB21538@mediacenter.austin.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2007 06:14 PM, Shawn Bohrer wrote:

> I can't speak for Fedora, but RHEL disables XFS in their kernel likely
> because it is known to cause problems with 4K stacks.

Okay. So is it fair to say it's largely XFS that's the problem? No problems 
with LVM/MD and say plain ext? If that's the case, I believe it could be 
concluded that it's not something in any sense fundamentally unfixable and 
the question becomes why XFS isn't fixed...

>>  Well, no. "oldconfig" works fine, and other than that, all failure modes 
>>  I've heard about also in this thread are MD/LVM/XFS. This is extremely 
>>  widely tested stuff in at least Fedora and RHEL.
> 
> Again don't assume that because Fedora and RHEL have 4K stacks means
> that MD/LVM/XFS is widely tested.

No, quite, that specific combination was reported in this thread alone 3 
times again, so that one's clear, but _other_ than that, I've heard of no 
other failure modes.

> Additionally I think I should point out that the problems pointed out so
> far are not the only problem areas with 4K stacks.  There are out of
> tree drivers to consider as well, and use cases like ndiswrapper.

Except these. Good to have pointed out, thanks, but as far as I'm concerned 
both these cases do not get a say in what's default configuration for the 
kernel.org kernel. They might get a say in what's removed or not removed 
from that kernel but that's not under discussion at the moment (nor would I 
expect it to be anytime soon if ever).

Rene.

