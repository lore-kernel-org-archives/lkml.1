Return-Path: <linux-kernel-owner+w=401wt.eu-S1759838AbYCZP6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759838AbYCZP6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 11:58:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759219AbYCZP5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 11:57:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37257 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759196AbYCZP5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 11:57:53 -0400
Message-ID: <47EA727B.8090606@zytor.com>
Date: Wed, 26 Mar 2008 08:57:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "J.C. Pizarro" <jcpiza@gmail.com>
CC: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: larger default page sizes...
References: <998d0e4a0803251647i2abefe96t34ec4ad6706afcfd@mail.gmail.com>
In-Reply-To: <998d0e4a0803251647i2abefe96t34ec4ad6706afcfd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J.C. Pizarro wrote:
> 
> But there is a general problem of larger pages in systems that
> don't support them natively (in hardware) depending in how it's
> implemented the memory manager in the kernel:
> 
>    "Doubling the soft page size implies
>       halfing the TLB soft-entries in the old hardware".
> 
>    "x4 soft page size=> 1/4 TLB soft-entries, ... and so on."
> 
> Assuming one soft double-sized page represents 2 real-sized pages,
> one replacing of one soft double-sized page implies replacing
> 2 TLB's entries containing the 2 real-sized pages.
> 
> The TLB is very small, its entries are around 24 entries aprox. in
> some processors!.
> 

That's not a problem, actually, since the TLB entries can get shuffled 
like any other (for software TLBs it's a little different, but it can be 
dealt with there too.)

The *real* problem is ABI breakage.

	-hpa
