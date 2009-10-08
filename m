Return-Path: <linux-kernel-owner+w=401wt.eu-S1757301AbZJHKmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301AbZJHKmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 06:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756947AbZJHKmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 06:42:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:41773 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756708AbZJHKmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 06:42:06 -0400
Message-ID: <4ACDC19F.7040401@kernel.org>
Date: Thu, 08 Oct 2009 19:40:31 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: cl@linux-foundation.org
CC: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V6 1/7] this_cpu_ops: page allocator conversion
References: <20091007211024.442168959@gentwo.org> <20091007211052.229772418@gentwo.org> <4ACDC11D.4030007@kernel.org>
In-Reply-To: <4ACDC11D.4030007@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 08 Oct 2009 10:40:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> This looks much better but I'm not sure whether it's safe.  percpu
> offsets have not been set up before setup_per_cpu_areas() is complete
> on most archs but if all that's necessary is getting the page
> allocator up and running as soon as static per cpu areas and offsets
> are set up (which basically means as soon as cpu init is complete on
> ia64 and setup_per_cpu_areas() is complete on all other archs).  This
> should be correct.  Is this what you're expecting?

Also, as I'm not very familiar with the code, I'd really appreciate
Mel Gorman's acked or reviewed-by.

Thanks.

-- 
tejun
