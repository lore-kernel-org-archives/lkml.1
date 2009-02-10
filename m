Return-Path: <linux-kernel-owner+w=401wt.eu-S1753747AbZBJJzC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbZBJJzC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 04:55:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbZBJJyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 04:54:53 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:50755 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbZBJJyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 04:54:52 -0500
Message-ID: <49914EE7.7030205@in.ibm.com>
Date: Tue, 10 Feb 2009 15:24:47 +0530
From: "Sachin P. Sant" <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       npiggin@suse.de
Subject: Re: next Feb 10: mm/slqb build break
References: <20090210194121.80256b72.sfr@canb.auug.org.au> <49914790.6050008@in.ibm.com>
In-Reply-To: <49914790.6050008@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sachin P. Sant wrote:
> Hi Stephen,
>
> Todays next randconfig build on powerpc fails with
>
>  CC      mm/slqb.o
> mm/slqb.c: In function __slab_free:
> mm/slqb.c:1648: error: implicit declaration of function 
> slab_free_to_remote
> mm/slqb.c: In function kmem_cache_open:
> mm/slqb.c:2174: error: implicit declaration of function 
> kmem_cache_dyn_array_free
> mm/slqb.c:2175: warning: label error_cpu_array defined but not used
> mm/slqb.c: In function kmem_cache_destroy:
> mm/slqb.c:2294: error: implicit declaration of function 
> claim_remote_free_list
> mm/slqb.c: In function kmem_cache_reap_percpu:
> mm/slqb.c:2547: error: implicit declaration of function 
> flush_remote_free_cache
> mm/slqb.c: In function kmem_cache_init:
> mm/slqb.c:2783: error: per_cpu__kmem_cpu_nodes undeclared (first use 
> in this function)
> mm/slqb.c:2783: error: (Each undeclared identifier is reported only once
> mm/slqb.c:2783: error: for each function it appears in.)
> mm/slqb.c:2784: error: kmem_cpu_cache undeclared (first use in this 
> function)
> make[1]: *** [mm/slqb.o] Error 1
> make: *** [mm] Error 2
CONFIG_SMP is not set hence the failure.

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

