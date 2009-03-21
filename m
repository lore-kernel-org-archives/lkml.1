Return-Path: <linux-kernel-owner+w=401wt.eu-S1757777AbZCUMNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777AbZCUMNZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 08:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754367AbZCUMNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 08:13:16 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:26945 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbZCUMNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 08:13:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ZwqD73nSw3hQYRHFua5EE5/kJvyz2wjJyFscIZh2rKP8h+XIrJk+uCIpCMBWOXzkfG
         TgC8B6J007r7KTCTY+M0Csp2L1gwUwBkOXqWtKAx7dG1jnljeWxLAsjGrCm1CkN6U02+
         CbwvSi8mIJkKVplWmpBwhgtjOqg4dVvh0Ef04=
Message-ID: <49C4D9C4.1030103@vflare.org>
Date: Sat, 21 Mar 2009 17:42:52 +0530
From: Nitin Gupta <nitingupta910@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, cl@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] xvmalloc memory allocator
References: <ztOQA2Cz.1237575719.7896090.penberg@cs.helsinki.fi>	<49C3F1EE.90903@vflare.org> <20090321032137.8dc113e8.akpm@linux-foundation.org>
In-Reply-To: <20090321032137.8dc113e8.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 21 Mar 2009 01:13:42 +0530 Nitin Gupta <ngupta@vflare.org> wrote:

> But what is regrettable is that xvmalloc appears to be tied to
> compressed-swap in some manner.  Is it not possible to split these two
> initiatives apart so that neither is dependent upon the other?  Or is
> compressed-swap hopelessly crippled without xvmalloc?

xvmalloc itself is completely independent of compressed-swap. Infact, its
loaded as separate kernel module (xvmalloc.ko)
However, this compression project is almost useless without this specialized
allocator.

> 
> (compcache is a terrible name, btw - it isn't a "compressed cache" at all!)
> 

I have now heard this many times and my conscious is beginning to hurt now :)
I will change it to match name of its block device: ramzswap   sounds better?

>> Anyways, I will move it to drivers/block.
> 
> This sounds like it might be a backward step.


I'm bit confused here. Last thing I want to do is block mainline merge
because of such issues. Its real pain to maintain these things separately.

Thanks,
Nitin
