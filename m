Return-Path: <linux-kernel-owner+w=401wt.eu-S1758832AbXKTF3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832AbXKTF3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 00:29:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758667AbXKTF30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 00:29:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41077 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758663AbXKTF3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 00:29:25 -0500
Message-ID: <47427076.7030702@zytor.com>
Date: Mon, 19 Nov 2007 21:28:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Adrian Bunk <bunk@kernel.org>, Willy Tarreau <w@1wt.eu>,
       Mark Lord <lkml@rtr.ca>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_IRQBALANCE for 64-bit x86 ?
References: <47425EA5.7000607@rtr.ca> <20071120042929.GD15227@1wt.eu> <20071120043742.GE6164@stusta.de> <200711201624.32611.nickpiggin@yahoo.com.au>
In-Reply-To: <200711201624.32611.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Tuesday 20 November 2007 15:37, Adrian Bunk wrote:
>> On Tue, Nov 20, 2007 at 05:29:29AM +0100, Willy Tarreau wrote:
> 
>>> Agreed. When userspace has something to do with the way IRQs are
>>> delivered, it's going to smell as bad as micro-kernels...
>> The next step to a micro-kernel would then be hardware drivers and file
>> systems in userspace?  ;-)
> 
> We already have those. So the next step would be to pretend the
> performance critical ones can be in userspace and remain competitive,
> wouldn't it? ;)

Hey, I have a great idea... we can create a microkernel^W hypervisor and 
make a single process^W domain do all the I/O...

	-hpa
