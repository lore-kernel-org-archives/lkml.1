Return-Path: <linux-kernel-owner+w=401wt.eu-S1756764AbZLISY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbZLISY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 13:24:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756379AbZLISYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 13:24:22 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:60641 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756344AbZLISYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 13:24:21 -0500
Date: Wed, 9 Dec 2009 12:23:29 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Mike Travis <travis@sgi.com>
cc: tony.luck@intel.com, Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <JBeulich@novell.com>, Tejun Heo <tj@kernel.org>,
       linux-mm@kvack.org, Geert Uytterhoeven <geert@linux-m68k.org>,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmalloc: don't use vmalloc_end
In-Reply-To: <4B1FE81F.30408@sgi.com>
Message-ID: <alpine.DEB.2.00.0912091218060.16491@router.home>
References: <4B1D3A3302000078000241CD@vpn.id2.novell.com> <20091207153552.0fadf335.akpm@linux-foundation.org> <4B1E1B1B0200007800024345@vpn.id2.novell.com> <alpine.DEB.2.00.0912091128280.16491@router.home> <4B1FE81F.30408@sgi.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Dec 2009, Mike Travis wrote:

> > Tony: Can you confirm that the new percpu stuff works on IA64? (Or is
> > there nobody left to care?)
>
> Christoph,  I have access to a 640p system for a couple more weeks if
> there's anything you'd like me to check out.

Boot with 2.6.32 and see if the per cpu allocator works. Check if there
are any changes to memory consumption. Create a few thousand virtual
ethernet devices and see if the system keels over.

It may also be good to run some scheduler test. Compare AIM9 of latest
SLES with 2.6.32. Concurrent page fault test? Then a performance test with
lots of concurrency but the usual stuff wont work since HPC apps usually
pin.

Run latencytest (available in the lldiag package) from
kernel.org/pub/linux/kernel/people/christoph/lldiag and see how the
disturbances by the OS are changed.

