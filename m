Return-Path: <linux-kernel-owner+w=401wt.eu-S1759961AbXEUIL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759961AbXEUIL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 04:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbXEUILw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 04:11:52 -0400
Received: from holomorphy.com ([66.93.40.71]:58738 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755214AbXEUILv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 04:11:51 -0400
Date: Mon, 21 May 2007 01:11:39 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] MM : alloc_large_system_hash() can free some memory for non power-of-two bucketsize
Message-ID: <20070521081139.GG19966@holomorphy.com>
References: <20070518115454.d3e32f4d.dada1@cosmosbay.com> <20070519182123.GD19966@holomorphy.com> <464F44BD.3040209@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464F44BD.3040209@cosmosbay.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III a ?crit :
>> The proper way to do this is to convert the large system hashtable
>> users to use some data structure / algorithm  other than hashing by
>> separate chaining.

On Sat, May 19, 2007 at 08:41:01PM +0200, Eric Dumazet wrote:
> No thanks. This was already discussed to death on netdev. To date, hash 
> tables are a good compromise.
> I dont mind losing part of memory, I prefer to keep good performance when 
> handling 1.000.000 or more tcp sessions.

The data structures perform well enough, but I suppose it's not worth
pushing the issue this way.


-- wli
