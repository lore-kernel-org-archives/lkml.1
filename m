Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942AbZA1INR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbZA1INR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 03:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbZA1IM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 03:12:58 -0500
Received: from rv-out-0506.google.com ([209.85.198.229]:46893 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbZA1IM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 03:12:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=U9vqmJG4zaT+UA0ro0wQ/EMnkqsfTzczuAtgCqzqt68NY54+vR4mxMcZQRLbLluhgR
         S2LpyFn2b28pyT3W/lS7Y6/hkPWlLoWBnEYRTmsdORJeEraNSp8AdWFcsMW9Ze0YrTx5
         QCMSzljkQcRMjmpWUKla4pbKNENEJr7DPM7Z4=
Message-ID: <49801378.6060407@gmail.com>
Date: Wed, 28 Jan 2009 17:12:40 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Herbert Xu <herbert@gondor.apana.org.au>, akpm@linux-foundation.org,
       hpa@zytor.com, brgerst@gmail.com, ebiederm@xmission.com,
       cl@linux-foundation.org, travis@sgi.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com, hugh@veritas.com,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH] percpu: add optimized generic percpu accessors
References: <20090115183942.GA6325@elte.hu> <200901201328.24605.rusty@rustcorp.com.au> <49756E6E.2060409@kernel.org> <200901271213.18605.rusty@rustcorp.com.au> <497E705B.5000302@kernel.org> <20090127131317.GF23121@elte.hu> <497F93A2.404@kernel.org> <497FD2AF.6020801@gmail.com>
In-Reply-To: <497FD2AF.6020801@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Okay, rebased on top of the current master[1].
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu
> 
> The rebased commit ID is e7f538f3d2a6b3a0a632190a7d736730ee10909c.
> 
> There were several changes which didn't fit the rebased tree as they
> really belong to other branches in the x86 tree.  I'll re-submit them
> as patches against the appropriate branch.

Two patches against #stackprotector and one against #cpus4096 sent
out.  With these three patches, most of stuff has been preserved but
there are still few missing pieces which only make sense after trees
are merged.  Will be happy to drive it if the current branch looks
fine.

Thanks.

-- 
tejun
