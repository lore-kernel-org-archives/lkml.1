Return-Path: <linux-kernel-owner+w=401wt.eu-S1763447AbZAUFxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763447AbZAUFxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 00:53:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756840AbZAUFxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 00:53:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:37623 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755673AbZAUFxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 00:53:14 -0500
Message-ID: <4976B82E.1080002@kernel.org>
Date: Wed, 21 Jan 2009 14:52:46 +0900
From: Tejun Heo <tj@kernel.org>
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
References: <20090115183942.GA6325@elte.hu> <200901170827.33729.rusty@rustcorp.com.au> <20090116220832.GB20653@elte.hu> <200901201328.24605.rusty@rustcorp.com.au> <20090120104022.GB29346@elte.hu>
In-Reply-To: <20090120104022.GB29346@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 21 Jan 2009 05:52:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> The larger point still remains: the kernel dominantly uses static percpu 
> variables by a margin of 10 to 1, so we cannot just brush away the static 
> percpu variables and must concentrate on optimizing that side with 
> priority. It's nice if the dynamic percpu-alloc side improves as well, of 
> course.

Well, the infrequent usage of dynamic percpu allocation is in some
part due to the poor implementation, so it's sort of chicken and egg
problem.  I got into this percpu thing because I wanted a percpu
reference count which can be dynamically allocated and it sucked.

Thanks.

-- 
tejun
