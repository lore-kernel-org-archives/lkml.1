Return-Path: <linux-kernel-owner+w=401wt.eu-S1759545AbXKTMLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545AbXKTMLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 07:11:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756802AbXKTMLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 07:11:11 -0500
Received: from ns2.suse.de ([195.135.220.15]:32943 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756312AbXKTMLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 07:11:10 -0500
From: Andi Kleen <ak@suse.de>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [rfc 08/45] cpu alloc: x86 support
Date: Tue, 20 Nov 2007 13:05:24 +0100
User-Agent: KMail/1.9.1
Cc: Christoph Lameter <clameter@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       akpm@linux-foundation.org, travis@sgi.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
References: <20071120011132.143632442@sgi.com> <Pine.LNX.4.64.0711191759370.19954@schroedinger.engr.sgi.com> <200711201459.12841.nickpiggin@yahoo.com.au>
In-Reply-To: <200711201459.12841.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711201305.24574.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > Yeah yea but the latencies are minimal making the NUMA logic too
> > expensive for most loads ... If you put a NUMA kernel onto those then
> > performance drops (I think someone measures 15-30%?)
>
> Small socket count systems are going to increasingly be NUMA in future.
> If CONFIG_NUMA hurts performance by that much on those systems, then the
> kernel is broken IMO.

Not sure where that number came from.

In my tests some time ago NUMA overhead on SMP was minimal.

This was admittedly with old 2.4 kernels. There have been some doubts about
some of the newer NUMA features added; in particular about NUMA slab;
don't think there was much trouble with anything else -- in fact the trouble
was that it apparently sometimes made moderate NUMA factor NUMA systems 
slower too. But I assume SLUB will address this anyways.

-Andi
