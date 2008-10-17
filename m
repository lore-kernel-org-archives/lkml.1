Return-Path: <linux-kernel-owner+w=401wt.eu-S1753076AbYJQGzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbYJQGzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 02:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751039AbYJQGzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 02:55:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51299 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbYJQGzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 02:55:23 -0400
Message-ID: <48F83609.4090407@zytor.com>
Date: Thu, 16 Oct 2008 23:51:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: benh@kernel.crashing.org, torvalds@linux-foundation.org, rdreier@cisco.com,
       Geert.Uytterhoeven@sonycom.com, linux-kernel@vger.kernel.org,
       mingo@elte.hu, yhlu.kernel@gmail.com, akpm@linux-foundation.org
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
References: <20081016.222108.13382080.davem@davemloft.net>	<1224225365.7654.88.camel@pasglop>	<48F83316.5080107@zytor.com> <20081016.234747.193703936.davem@davemloft.net>
In-Reply-To: <20081016.234747.193703936.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
>>>
>> IMNSHO I think you can default to 8 digits for I/O for PCI, since at least last I looked there was no 64-bit address space possible for I/O.
> 
> Resources are representing different things on different platforms.
> 
> On sparc64 it's actually the full 64-bit physical I/O address on the
> system bus being stored in there.  So even IORESOURCE_IO objects have
> 64-bits of relevancy.
> 

And then it should be printed as such on that platform.

> Like I said, printing out the entire thing has helped me find real
> bugs, so printing the whole thing is not without merit.

No argument there.  I was referring only to platforms where the resource 
contains a PCI I/O address, which is 32 bits long unless limited by 
additional constraints (like x86's 16-bit limit.)

	-hpa
