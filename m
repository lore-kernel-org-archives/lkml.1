Return-Path: <linux-kernel-owner+w=401wt.eu-S934219AbXKOHOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934219AbXKOHOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 02:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765123AbXKOHMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 02:12:03 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35449
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933999AbXKOHL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 02:11:57 -0500
Date: Wed, 14 Nov 2007 23:11:47 -0800 (PST)
Message-Id: <20071114.231147.223986050.davem@davemloft.net>
To: dada1@cosmosbay.com
Cc: russ@elegant-software.com, linux-kernel@vger.kernel.org
Subject: Re: OT: Does Linux have any "Perfect Code"
From: David Miller <davem@davemloft.net>
In-Reply-To: <473BE75B.9070701@cosmosbay.com>
References: <c9d133bdb3481fbc01a572d948049f5e@elegant-software.com>
	<473BE75B.9070701@cosmosbay.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>
Date: Thu, 15 Nov 2007 07:29:47 +0100

> hrtime_t
> ts2hrt(const timestruc_t *tsp)
> {
> return tsp->tv_sec * NANOSEC + tsp->tv_nsec;
> }
> 
> can be inlined as it is trivial (and much faster than Solaris version)
> 
>          movq    (%rdi), %rdx
>          mov     8(%rdi), %eax
>          imulq   $1000000000, %rdx, %rdx
>          addq    %rdx, %rax

This is exactly the kind of thing that is not happening to the Solaris
code base.  These gradual improvements that are being done constantly
to every nook and cranny of the Linux kernel.

Code sits untouched for 6+ years in the Solaris tree not because it's
perfect and bug free, but rather because Sun simply does not have the
environment and resources with which to make the kinds of ongoing
improvements Linux can.

The things Sun is trying to say is so great about the Solaris code
base is actually, as shown by Eric, it's greatest weakness.
Development is glacial and a lot of stuff simply does not get looked
at.

Someone who really wants to get some kind of idea on what scale Linux
development is compared to Solaris should sit down with a current
Linux git tree and a current OpenSolaris mercurial checkout and do
some comparisons.

Here is one you could ferret out that I am pretty sure of.  I bet that
in the 2.6.24 merge window (1.5 weeks of merging patches) we had more
individual contributors to the Linux kernel than OpenSolaris has had
in it's entire existence.
