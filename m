Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbZCLMIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbZCLMIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 08:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754982AbZCLMHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 08:07:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:46308 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754694AbZCLMHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 08:07:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,350,1233561600"; 
   d="scan'208";a="119519741"
Date: Thu, 12 Mar 2009 20:06:49 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: jack marrow <jackmarrow2@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: Memory usage per memory zone
Message-ID: <20090312120649.GA20854@localhost>
References: <e2dc2c680903110516v2c66d4a4h6a422cffceb12e2@mail.gmail.com> <20090311122611.GA8804@localhost> <e2dc2c680903120053w37968c1cy556812cef63f0896@mail.gmail.com> <20090312075952.GA19331@localhost> <e2dc2c680903120104h4d19a3f6j57ad045bc06f9a90@mail.gmail.com> <20090312081113.GA19506@localhost> <e2dc2c680903120117j7be962b2xd63f3296f8f65a46@mail.gmail.com> <20090312103847.GA20210@localhost> <e2dc2c680903120438i27e209c2h28c61704299b8b4f@mail.gmail.com> <e2dc2c680903120448q386f84a4t5667e22751002ae9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e2dc2c680903120448q386f84a4t5667e22751002ae9@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 01:48:50PM +0200, jack marrow wrote:
> >> Sure, but something is unreclaimable... Maybe some process is taking a
> >> lot of shared memory(shm)? What's the output of `lsof`?
> >
> > I can't paste that, but I expect oracle is using it.
> 
> Maybe this is helpful:
> 
> #  ipcs |grep oracle
> 0x00000000 2293770    oracle    640        4194304    22
> 0x00000000 2326539    oracle    640        536870912  22
> 0x880f3334 2359308    oracle    640        266338304  22
> 0x0f9b5efc 1933312    oracle    640        44

Up to 800M shm...

http://lwn.net/Articles/286485/
http://feedblog.org/2009/01/25/splitlru-patch-in-kernel-2628-must-have-for-mysql-and-innodb/

which reads: 

        If you’re running MySQL with InnoDB and an in-memory buffer pool, and
        having paging issues, you probably should upgrade to 2.6.28 ASAP.


Thanks,
Fengguang
