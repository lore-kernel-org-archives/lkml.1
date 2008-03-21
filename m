Return-Path: <linux-kernel-owner+w=401wt.eu-S1756647AbYCUHbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbYCUHbB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 03:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbYCUHat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 03:30:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40673
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753866AbYCUHas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 03:30:48 -0400
Date: Fri, 21 Mar 2008 00:31:00 -0700 (PDT)
Message-Id: <20080321.003100.155729406.davem@davemloft.net>
To: dada1@cosmosbay.com
Cc: clameter@sgi.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [14/14] vcompound: Avoid vmalloc for ehash_locks
From: David Miller <davem@davemloft.net>
In-Reply-To: <47E35D73.6060703@cosmosbay.com>
References: <20080321061703.921169367@sgi.com>
	<20080321061727.491610308@sgi.com>
	<47E35D73.6060703@cosmosbay.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>
Date: Fri, 21 Mar 2008 08:02:11 +0100

> But, isnt it defeating the purpose of this *particular* vmalloc() use ?
> 
> CONFIG_NUMA and vmalloc() at boot time means :
> 
> Try to distribute the pages on several nodes.
> 
> Memory pressure on ehash_locks[] is so high we definitly want to spread it.
> 
> (for similar uses of vmalloc(), see also hashdist=1 )
> 
> Also, please CC netdev for network patches :)

I agree with Eric, converting any of the networking hash
allocations to this new facility is not the right thing
to do.
