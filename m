Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbZLVWiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbZLVWiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 17:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754643AbZLVWiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 17:38:23 -0500
Received: from waste.org ([173.11.57.241]:47553 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbZLVWiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 17:38:22 -0500
Subject: Re: [PATCH] slab: initialize unused alien cache entry as NULL at
 alloc_alien_cache().
From: Matt Mackall <mpm@selenic.com>
To: Haicheng Li <haicheng.li@linux.intel.com>
Cc: linux-mm@kvack.org, Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4B30BDA8.1070904@linux.intel.com>
References: <4B30BDA8.1070904@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Dec 2009 16:38:05 -0600
Message-ID: <1261521485.3000.1692.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-22 at 20:38 +0800, Haicheng Li wrote:

>   	ac_ptr = kmalloc_node(memsize, gfp, node);
>   	if (ac_ptr) {
> +		memset(ac_ptr, 0, memsize);

Please use kzalloc_node here.

I'm not sure what's going on with nr_node_id vs MAX_NUMNODES, so I think
we need to see an answer to Christoph's question before going forward
with this.

-- 
http://selenic.com : development and support for Mercurial and Linux


