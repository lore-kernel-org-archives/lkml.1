Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab0BSQ72 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 11:59:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37369 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090Ab0BSQ70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 11:59:26 -0500
Message-ID: <4B7EC20C.30607@zytor.com>
Date: Fri, 19 Feb 2010 08:53:32 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH] x86: Add optimized popcnt variants
References: <4B758FC0.1020600@zytor.com> <20100212174751.GD3114@aftab> <4B75A66A.70005@zytor.com> <4B7BF5D6.3030701@suse.cz> <20100217172040.GC13429@aftab> <4B7C27D8.9050408@suse.cz> <4B7C29C1.10906@suse.cz> <20100218061923.GA1594@liondog.tnic> <20100219142205.GA32533@aftab> <4B7EB6EF.9010405@zytor.com> <20100219164512.GA492@aftab>
In-Reply-To: <20100219164512.GA492@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2010 08:45 AM, Borislav Petkov wrote:
>>
>> You're still not inlining these.  They should be: there is absolutely no
>> reason for code size to not inline them anymore.
> 
> Isn't better to have only those 4 locations for apply_alternatives to
> patch wrt to popcnt instead of sprinkling alternatives sections around
> the kernel in every callsite of hweight and its users? Or is the aim to
> optimize even that "call __arch_hweightXX" away?
> 

That's the idea, yes.  We use inline alternatives in quite a few other
places.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

