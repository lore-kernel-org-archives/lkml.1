Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751761AbYLQSL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbYLQSL6 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 13:11:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750855AbYLQSLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 13:11:48 -0500
Received: from relay2.sgi.com ([192.48.179.30]:43983 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750774AbYLQSLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 13:11:47 -0500
Message-ID: <494940E0.704@sgi.com>
Date: Wed, 17 Dec 2008 10:11:44 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@redhat.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] cpumask: add alloc_cpumask_var_node V2
References: <49471353.9070204@sgi.com> <494724E7.4090701@sgi.com> <49472C59.4030104@sgi.com> <200812172218.12608.rusty@rustcorp.com.au>
In-Reply-To: <200812172218.12608.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Tuesday 16 December 2008 14:49:37 Mike Travis wrote:
>> Add alloc_cpumask_var_node.  This will be needed in x86 code to
>> allocate the domain and old_domain cpumasks on the same node as
>> where the containing irq_cfg struct is allocated.
> 
> OK, this is understandable.  If you don't mind I'll split this patch
> into documentation and node patches separately.
> 
> Since kmalloc(size, gfp) == kmalloc_node(size, gfp, -1), I think
> we can change this to implement alloc_cpumask_var() in terms of
> alloc_cpumask_var_node(..., numa_node_id()).
> 

Cool, thanks!

Mike
