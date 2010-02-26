Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965570Ab0BZRzQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 12:55:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54655 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965482Ab0BZRzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 12:55:13 -0500
Message-ID: <4B88097E.7010608@zytor.com>
Date: Fri, 26 Feb 2010 09:48:46 -0800
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
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: Add optimized popcnt variants
References: <20100222141737.GB21233@aftab> <4B82BD01.3030008@zytor.com> <20100222184945.GD21233@aftab> <4B82E144.1050007@zytor.com> <20100223155852.GF30382@aftab> <4B84118C.90203@zytor.com> <20100223175457.GA2401@aftab> <4B841BC3.1000908@zytor.com> <20100223190614.GB2401@aftab> <4B875BBD.4060104@zytor.com> <20100226074714.GA15310@aftab>
In-Reply-To: <20100226074714.GA15310@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2010 11:47 PM, Borislav Petkov wrote:
> From: "H. Peter Anvin" <hpa@zytor.com>
> Date: Thu, Feb 25, 2010 at 09:27:25PM -0800
> 
>> OK, this patch looks pretty good now, but I'm completely lost as to
>> what the baseline of this patch is supposed to be.
> 
> Yeah, this is based on PeterZ's http://lkml.org/lkml/2010/2/4/119
> 
> But I'm not sure which tree has it...
> 

Looks like -mm, which really means that either Andrew has to take your
patch, too, or we have to wait until that is upstream until we can merge
your patch.

I'm a little nervous about just acking the patch and telling Andrew to
test it, because I don't know what the fallout would look like.  I'm
particularly concerned about gcc version dependencies.

I guess, on the other hand, if it ends up not getting merged until .35
it's not a huge deal either.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

