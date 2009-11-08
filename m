Return-Path: <linux-kernel-owner+w=401wt.eu-S1754394AbZKHM3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394AbZKHM3l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 07:29:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753946AbZKHM3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 07:29:40 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46845 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959AbZKHM3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 07:29:40 -0500
Message-ID: <4AF6B9B1.2030200@cs.helsinki.fi>
Date: Sun, 08 Nov 2009 14:29:37 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Alan Cox <alan@linux.intel.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH] slqb: A not quite so trivial warning
References: <20091106112942.14595.29799.stgit@localhost.localdomain> <4AF6ADE1.60201@cs.helsinki.fi> <4AF6B3C6.8080407@kernel.org>
In-Reply-To: <4AF6B3C6.8080407@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> Pekka Enberg wrote:
>> Alan Cox wrote:
>>> mm/slqb.c:2773: warning: initialization from incompatible pointer type
>>>
>>> Variable scope...
>>>
>>> Signed-off-by: Alan Cox <alan@linux.intel.com>
>> I don't see this warning in my tree. Is this coming from linux-next? Did
>> someone change DEFINE_PER_CPU not to prefix the variable name with
>> "per_cpu__"?
> 
> Yeap, the prefix is dropped in the latest percpu tree.  Patch already
> pending.
> 
>   http://patchwork.kernel.org/patch/56948/
> 
> Thanks.

OK, I applied the above patch. Please CC me on patches that have the 
magic letters S, L, and B in the future.

			Pekka
