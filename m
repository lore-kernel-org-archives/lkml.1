Return-Path: <linux-kernel-owner+w=401wt.eu-S1756520AbZLISKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520AbZLISKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 13:10:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756557AbZLISKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 13:10:41 -0500
Received: from relay1.sgi.com ([192.48.179.29]:37202 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756414AbZLISKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 13:10:41 -0500
Message-ID: <4B1FE81F.30408@sgi.com>
Date: Wed, 09 Dec 2009 10:10:39 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: tony.luck@intel.com, Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <JBeulich@novell.com>, Tejun Heo <tj@kernel.org>,
       linux-mm@kvack.org, Geert Uytterhoeven <geert@linux-m68k.org>,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmalloc: don't use vmalloc_end
References: <4B1D3A3302000078000241CD@vpn.id2.novell.com> <20091207153552.0fadf335.akpm@linux-foundation.org> <4B1E1B1B0200007800024345@vpn.id2.novell.com> <alpine.DEB.2.00.0912091128280.16491@router.home>
In-Reply-To: <alpine.DEB.2.00.0912091128280.16491@router.home>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Christoph Lameter wrote:
> On Tue, 8 Dec 2009, Jan Beulich wrote:
> 
>> According to Tejun the problem is just cosmetic (i.e. causes build
>> warnings), since the functions affected aren't being used (yet) on
>> ia64. So feel free to drop the patch again, given that he has a patch
>> queued to address the issue by renaming the arch variable.
> 
> I thought the new code must be used in order for the new percpu allocator
> to work? Or is this referring to other code?
> 
>> I wonder though why that code is being built on ia64 at all if it's not
>> being used (i.e. why it doesn't depend on a CONFIG_*, HAVE_*, or
>> NEED_* manifest constant).
> 
> Tony: Can you confirm that the new percpu stuff works on IA64? (Or is
> there nobody left to care?)

Christoph,  I have access to a 640p system for a couple more weeks if
there's anything you'd like me to check out.

Thanks,
Mike
