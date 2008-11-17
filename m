Return-Path: <linux-kernel-owner+w=401wt.eu-S1752495AbYKQNP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbYKQNP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 08:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYKQNPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 08:15:50 -0500
Received: from cmpxchg.org ([85.214.51.133]:46190 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbYKQNPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 08:15:50 -0500
Date: Mon, 17 Nov 2008 14:14:40 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <20081117131440.GB29931@cmpxchg.org>
References: <492162E4.9080902@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492162E4.9080902@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lai,

On Mon, Nov 17, 2008 at 08:26:12PM +0800, Lai Jiangshan wrote:
> +/**
> + * kvfree - free the memory by kfree(), or vfree() if it is vmalloc addr

Could that be just `free the memory allocated by kvmalloc()'?

	Hannes
