Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711Ab0BZFeo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 00:34:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42599 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453Ab0BZFem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 00:34:42 -0500
Message-ID: <4B875BBD.4060104@zytor.com>
Date: Thu, 25 Feb 2010 21:27:25 -0800
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
References: <20100219164512.GA492@aftab> <4B7EC20C.30607@zytor.com> <20100222141737.GB21233@aftab> <4B82BD01.3030008@zytor.com> <20100222184945.GD21233@aftab> <4B82E144.1050007@zytor.com> <20100223155852.GF30382@aftab> <4B84118C.90203@zytor.com> <20100223175457.GA2401@aftab> <4B841BC3.1000908@zytor.com> <20100223190614.GB2401@aftab>
In-Reply-To: <20100223190614.GB2401@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2010 11:06 AM, Borislav Petkov wrote:
> 
> Ok, here you go.
> 
> --
> From: Borislav Petkov <borislav.petkov@amd.com>
> Date: Thu, 11 Feb 2010 00:48:31 +0100
> Subject: [PATCH] x86: Add optimized popcnt variants
> 
> Add support for the hardware version of the Hamming weight function,
> popcnt, present in CPUs which advertize it under CPUID, Function
> 0x0000_0001_ECX[23]. On CPUs which don't support it, we fallback to the
> default lib/hweight.c sw versions.
> 
> A synthetic benchmark comparing popcnt with __sw_hweight64 showed almost
> a 3x speedup on a F10h machine.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

OK, this patch looks pretty good now, but I'm completely lost as to what
the baseline of this patch is supposed to be.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

