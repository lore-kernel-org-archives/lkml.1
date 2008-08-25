Return-Path: <linux-kernel-owner+w=401wt.eu-S1756615AbYHYSDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbYHYSDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 14:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbYHYSDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 14:03:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753685AbYHYSDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 14:03:14 -0400
Date: Mon, 25 Aug 2008 11:02:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
 bisected
In-Reply-To: <48B2A91F.8000302@hp.com>
Message-ID: <alpine.LFD.1.10.0808251100500.3363@nehalem.linux-foundation.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <VSpL6AnBTS.A.q9H.6aGsIB@albercik> <alpine.LFD.1.10.0808231257310.3363@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808231313170.3363@nehalem.linux-foundation.org> <48B2A91F.8000302@hp.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 25 Aug 2008, Alan D. Brunelle wrote:
> 
> With /just/ DEBUG_PAGE_ALLOC defined, I have seen two general panic types:
> 
> o  A new double fault w/ SMP_DEBUG_PAGEALLOC problem (prob4.txt)

Yeah, that's a stack overflow.

Confirmed.

			Linus
