Return-Path: <linux-kernel-owner+w=401wt.eu-S1754940AbYKPFws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbYKPFws (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 00:52:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbYKPFwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 00:52:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:40905 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbYKPFwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 00:52:40 -0500
Date: Sat, 15 Nov 2008 21:53:09 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       kamezawa.hiroyu@jp.fujitsu.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "David S. Miller" <davem@davemloft.net>, Jan Kara <jack@suse.cz>,
       Jes Sorensen <jes@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] mm: introduce simple_malloc()/simple_free()
Message-ID: <20081115215309.7f29c33c@infradead.org>
In-Reply-To: <491FB107.6050703@cn.fujitsu.com>
References: <491FA28B.2070003@cn.fujitsu.com>
	<20081115205229.765f7ee3@infradead.org>
	<20081115210334.3870cdf6.akpm@linux-foundation.org>
	<491FB107.6050703@cn.fujitsu.com>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Nov 2008 13:35:03 +0800
Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> 
> vmalloc() is not good for performance and increasing fragment.
> but vmalloc() is need for some subsystems' alternative malloc,
> like cgroup's tasks file and other subsystems(about 20 subsystems).

actually what you are pointing out is that these areas need improvement
to not need such huge blocks of memory... but only a series of smaller
blocks instead.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
