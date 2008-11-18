Return-Path: <linux-kernel-owner+w=401wt.eu-S1751724AbYKRIyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbYKRIyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 03:54:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbYKRIyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 03:54:22 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50141 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbYKRIyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 03:54:21 -0500
Message-ID: <492281F3.2060706@cn.fujitsu.com>
Date: Tue, 18 Nov 2008 16:50:59 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Miller <davem@davemloft.net>, Dave Airlie <airlied@gmail.com>,
       Paul Menage <menage@google.com>, kamezawa.hiroyu@jp.fujitsu.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>, Jan Kara <jack@suse.cz>,
       Jes Sorensen <jes@sgi.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, dada1@cosmosbay.com,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nick Piggin <npiggin@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH V2 0/4] use kvmalloc()/kvfree() the second part, about RCU
References: <492162E4.9080902@cn.fujitsu.com> <20081117131440.GB29931@cmpxchg.org>
In-Reply-To: <20081117131440.GB29931@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

I have sent patch for introducing kvmalloc()/kvfree().
http://lkml.org/lkml/2008/11/17/137

and 6 patches for using kvmalloc()/kvfree() (these patches need to be fixed)

fdtable and sysipc uses vfree() in the RCU callback.
Now, these patches cleanup for them.

any comments are welcome.

Thanx, Lai.

