Return-Path: <linux-kernel-owner+w=401wt.eu-S2992459AbXBIRuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992459AbXBIRuF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 12:50:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992463AbXBIRuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 12:50:04 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:48466 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992457AbXBIRuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 12:50:01 -0500
Date: Fri, 9 Feb 2007 18:45:54 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
In-Reply-To: <Pine.LNX.4.61.0702090755530.7642@chaos.analogic.com>
Message-ID: <Pine.LNX.4.61.0702091842450.31955@yvahk01.tjqt.qr>
References: <45CB3B28.60102@garzik.org> <Pine.LNX.4.64.0702080819350.8424@woody.linux-foundation.org>
 <Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org>
 <Pine.LNX.4.61.0702082202180.24888@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0702081324090.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702081432320.27603@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0702081528070.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702081554380.29559@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0702081632200.8424@woody.linux-foundation.org>
 <Pine.LNX.4.61.0702091330380.31955@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0702090755530.7642@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 9 2007 08:16, linux-os (Dick Johnson) wrote:
>On Fri, 9 Feb 2007, Jan Engelhardt wrote:
>> On Feb 8 2007 16:42, Linus Torvalds wrote:
>>>
>> Further, giving again answer to the question whether they generate
>> signed or unsigned comparisons: Have you ever seen a computer which
>> addresses memory with negative numbers? Since the answer is most likely
>> no, signed comparisons would
>
>Yes, most all do. Indexed memory operands are signed displacements. See
>page 2-16, Intel486 Microprocessor Programmer's Reference Manual. This

I was referring to "absolute memory", not the offset magic that assembler
allows. After all, (reg+relativeOffset) will yield an absolute address.
What I was out at: for machines that have more than 2 GB of memory, you
don't call the address that is given by 0x80000000U actually "byte
-2147483648", but "byte 2147483648".

>gets hidden by higher-level languages such as 'C'. It is also non-obvious
>when using the AT&T (GNU) assembly language. However, the Intel documentation
>shows it clearly:
> 			MOV	AL,  [EBX+0xFFFFFFFF]	; -1

It can be debated what exactly this is... negative offset or "using
overflow to get where we want".



Jan
-- 
ft: http://freshmeat.net/p/chaostables/
