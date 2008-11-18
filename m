Return-Path: <linux-kernel-owner+w=401wt.eu-S1752477AbYKRAbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbYKRAbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 19:31:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620AbYKRAbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 19:31:42 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50924 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbYKRAbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 19:31:41 -0500
Message-ID: <49220C1F.8040509@cn.fujitsu.com>
Date: Tue, 18 Nov 2008 08:28:15 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Dave Airlie <airlied@gmail.com>,
       Paul Menage <menage@google.com>, kamezawa.hiroyu@jp.fujitsu.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>, Jan Kara <jack@suse.cz>,
       Jes Sorensen <jes@sgi.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, dada1@cosmosbay.com,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 1/1] mm: introduce kvmalloc()/kvfree()
References: <492162E4.9080902@cn.fujitsu.com> <20081117131440.GB29931@cmpxchg.org>
In-Reply-To: <20081117131440.GB29931@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:
> Hi Lai,
> 
> On Mon, Nov 17, 2008 at 08:26:12PM +0800, Lai Jiangshan wrote:
>> +/**
>> + * kvfree - free the memory by kfree(), or vfree() if it is vmalloc addr
> 
> Could that be just `free the memory allocated by kvmalloc()'?
> 
> 	Hannes
> 
> 
> 


We don't and we won't introduce another allocator, kvmalloc() is
a wrapper of kmalloc() and vmalloc(), and kvfree() is a wrapper
of kfree() and vfree()

	Lai.

