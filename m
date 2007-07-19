Return-Path: <linux-kernel-owner+w=401wt.eu-S932161AbXGSAuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161AbXGSAuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 20:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbXGSAt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 20:49:59 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:51967 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbXGSAt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 20:49:58 -0400
Message-ID: <469EB4E5.2040300@gmail.com>
Date: Thu, 19 Jul 2007 02:48:37 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Andrea Arcangeli <andrea@suse.de>, Ray Lee <ray-lk@madrabbit.org>,
       Bodo Eggert <7eggert@gmx.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
References: <E1IA7j1-0000j9-I3@be1.lrz> <469A5D7C.5010904@gmail.com> <Pine.LNX.4.58.0707161523500.25779@be1.lrz> <469BF104.1040703@gmail.com> <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com> <469BF768.6040200@gmail.com> <20070716230719.GC11115@waste.org> <469BFB73.3070105@gmail.com> <20070716232755.GD11115@waste.org> <20070719001539.GC29728@v2.random> <20070719004129.GN11115@waste.org>
In-Reply-To: <20070719004129.GN11115@waste.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2007 02:41 AM, Matt Mackall wrote:

> On Thu, Jul 19, 2007 at 02:15:39AM +0200, Andrea Arcangeli wrote:

>> Using kmalloc(8k) instead of alloc_page() doesn't sound a too big deal
>> and that will solve the problem.
> 
> How do you figure?
> 
> If you're saying that soft pages helps our 8k stack allocations, it
> doesn't. The memory overhead of soft pages will be higher (5-15%,
> mostly due to file tails in pagecache) than the level at which 8k
> stacks currently run into trouble (1-2% free?).
> 
> Not helpful.

With tail-packing it is.

Rene.

