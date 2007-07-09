Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbXGIJru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbXGIJru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 05:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbXGIJro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 05:47:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:56269 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbXGIJrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 05:47:43 -0400
Subject: Re: [RFC/PATCH] Use mmu_gather for fork() instead of flush_tlb_mm()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: linux-mm@kvack.org, Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <4691FFDC.5020808@yahoo.com.au>
References: <1183952874.3388.349.camel@localhost.localdomain>
	 <1183962981.5961.3.camel@localhost.localdomain>
	 <1183963544.5961.6.camel@localhost.localdomain>
	 <4691E64F.5070506@yahoo.com.au>
	 <1183972349.5961.25.camel@localhost.localdomain>
	 <4691FFDC.5020808@yahoo.com.au>
Content-Type: text/plain
Date: Mon, 09 Jul 2007 19:47:38 +1000
Message-Id: <1183974458.5961.42.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-09 at 19:29 +1000, Nick Piggin wrote:
> They could just #define one to the other though, there are only a
> small
> number of them. Is there a downside to not making them distinct? i386
> for example probably would just keep doing a tlb flush for fork and
> not
> want to worry about touching the tlb gather stuff.

But the tlb gather stuff just does ... a flush_tlb_mm() on x86 :-)

I really think it's the right API

Ben.


