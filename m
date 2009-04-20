Return-Path: <linux-kernel-owner+w=401wt.eu-S1754472AbZDTXma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbZDTXma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 19:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbZDTXmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 19:42:20 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:49221 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbZDTXmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 19:42:20 -0400
Message-ID: <49ED0869.5090507@oracle.com>
Date: Mon, 20 Apr 2009 16:42:33 -0700
From: Randy Dunlap <randy.dunlap_ocs10g@oracle.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next ia64 build problems in slqb
References: <49ecf25e2378234eed@agluck-desktop.sc.intel.com>
In-Reply-To: <49ecf25e2378234eed@agluck-desktop.sc.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.49ED0852.0292:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luck, Tony wrote:
> The ia64 "allnoconfig" build ends up with the (possibly dubious) combination
> of .config options:
> 
> 	CONFIG_SMP=n
> 	CONFIG_NUMA=y
> 
> which leads to the following build problems with mm/slqb.c
> 
>   CC      mm/slqb.o
> mm/slqb.c: In function ‘__slab_free’:
> mm/slqb.c:1735: error: implicit declaration of function ‘slab_free_to_remote’
> mm/slqb.c: In function ‘kmem_cache_open’:
> mm/slqb.c:2274: error: implicit declaration of function ‘kmem_cache_dyn_array_free’
> mm/slqb.c:2275: warning: label ‘error_cpu_array’ defined but not used
> mm/slqb.c: In function ‘kmem_cache_destroy’:
> mm/slqb.c:2395: error: implicit declaration of function ‘claim_remote_free_list’
> mm/slqb.c: In function ‘kmem_cache_init’:
> mm/slqb.c:2885: error: ‘per_cpu__kmem_cpu_nodes’ undeclared (first use in this function)
> mm/slqb.c:2885: error: (Each undeclared identifier is reported only once
> mm/slqb.c:2885: error: for each function it appears in.)
> mm/slqb.c:2886: error: ‘kmem_cpu_cache’ undeclared (first use in this function)

Does this patch fix it?

http://lkml.org/lkml/2009/4/20/30

