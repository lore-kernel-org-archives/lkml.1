Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab0BWSWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 13:22:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53964 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab0BWSWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 13:22:05 -0500
Message-ID: <4B841BC3.1000908@zytor.com>
Date: Tue, 23 Feb 2010 10:17:39 -0800
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
References: <20100219142205.GA32533@aftab> <4B7EB6EF.9010405@zytor.com> <20100219164512.GA492@aftab> <4B7EC20C.30607@zytor.com> <20100222141737.GB21233@aftab> <4B82BD01.3030008@zytor.com> <20100222184945.GD21233@aftab> <4B82E144.1050007@zytor.com> <20100223155852.GF30382@aftab> <4B84118C.90203@zytor.com> <20100223175457.GA2401@aftab>
In-Reply-To: <20100223175457.GA2401@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2010 09:54 AM, Borislav Petkov wrote:
> 
> Right, doh. Ok, just added it and it builds fine with a gcc (Gentoo
> 4.4.1 p1.0) 4.4.1. If you have suspicion that some older gcc versions
> might choke on it, I could leave the "=D" dummy constraint in?
> 

I can try it with gcc 3.4 here.  -fcall-saved-rdi is cleaner, if it works.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

