Return-Path: <linux-kernel-owner+w=401wt.eu-S1755622AbXL1AUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622AbXL1AUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 19:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755563AbXL1ASM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 19:18:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37290
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755804AbXL1ASK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 19:18:10 -0500
Date: Thu, 27 Dec 2007 16:18:09 -0800 (PST)
Message-Id: <20071227.161809.92032908.davem@davemloft.net>
To: travis@sgi.com
Cc: akpm@linux-foundation.org, clameter@sgi.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, ak@suse.de
Subject: Re: [PATCH 03/10] percpu: Make the asm-generic/percpu.h more
 "generic"
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071228001047.292111000@sgi.com>
References: <20071228001046.854702000@sgi.com>
	<20071228001047.292111000@sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: travis@sgi.com
Date: Thu, 27 Dec 2007 16:10:49 -0800

> V1->V2:
> - add support for PER_CPU_ATTRIBUTES
> 
> Add the ability to use generic/percpu even if the arch needs to override
> several aspects of its operations. This will enable the use of generic
> percpu.h for all arches.
> 
> An arch may define:
> 
> __per_cpu_offset	Do not use the generic pointer array. Arch must
> 			define per_cpu_offset(cpu) (used by x86_64, s390).
> 
> __my_cpu_offset		Can be defined to provide an optimized way to determine
> 			the offset for variables of the currently executing
> 			processor. Used by ia64, x86_64, x86_32, sparc64, s/390.
> 
> SHIFT_PTR(ptr, offset)	If an arch defines it then special handling
> 			of pointer arithmentic may be implemented. Used
> 			by s/390.
> 
> 
> (Some of these special percpu arch implementations may be later consolidated
> so that there are less cases to deal with.)
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Andi Kleen <ak@suse.de>
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> Signed-off-by: Mike Travis <travis@sgi.com>

Acked-by: David S. Miller <davem@davemloft.net>
