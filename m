Return-Path: <linux-kernel-owner+w=401wt.eu-S1756998AbZLIShT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998AbZLIShT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 13:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756594AbZLIShP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 13:37:15 -0500
Received: from relay3.sgi.com ([192.48.152.1]:40850 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756523AbZLIShN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 13:37:13 -0500
Message-ID: <4B1FEE5C.1030303@sgi.com>
Date: Wed, 09 Dec 2009 10:37:16 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: tony.luck@intel.com, Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <JBeulich@novell.com>, Tejun Heo <tj@kernel.org>,
       linux-mm@kvack.org, Geert Uytterhoeven <geert@linux-m68k.org>,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmalloc: don't use vmalloc_end
References: <4B1D3A3302000078000241CD@vpn.id2.novell.com> <20091207153552.0fadf335.akpm@linux-foundation.org> <4B1E1B1B0200007800024345@vpn.id2.novell.com> <alpine.DEB.2.00.0912091128280.16491@router.home> <4B1FE81F.30408@sgi.com> <alpine.DEB.2.00.0912091218060.16491@router.home>
In-Reply-To: <alpine.DEB.2.00.0912091218060.16491@router.home>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Christoph Lameter wrote:
> On Wed, 9 Dec 2009, Mike Travis wrote:
> 
>>> Tony: Can you confirm that the new percpu stuff works on IA64? (Or is
>>> there nobody left to care?)
>> Christoph,  I have access to a 640p system for a couple more weeks if
>> there's anything you'd like me to check out.
> 
> Boot with 2.6.32 and see if the per cpu allocator works. Check if there
> are any changes to memory consumption. Create a few thousand virtual
> ethernet devices and see if the system keels over.

Any advice on how to go about the above would be helpful... ;-)

> 
> It may also be good to run some scheduler test. Compare AIM9 of latest
> SLES with 2.6.32. Concurrent page fault test? Then a performance test with
> lots of concurrency but the usual stuff wont work since HPC apps usually
> pin.

I'm doing some aim7/9 comparisons right now between SPARSE and DISCONTIG
memory configs using sles11 + 2.6.32.  Which other benchmarks would you
recommend for the other tests?

> 
> Run latencytest (available in the lldiag package) from
> kernel.org/pub/linux/kernel/people/christoph/lldiag and see how the
> disturbances by the OS are changed.

I'll put that on the list.
