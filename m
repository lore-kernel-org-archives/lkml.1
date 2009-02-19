Return-Path: <linux-kernel-owner+w=401wt.eu-S1755678AbZBSIeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678AbZBSIeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 03:34:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411AbZBSIdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 03:33:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:45220 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207AbZBSIdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 03:33:53 -0500
Subject: Re: [PATCH 2/3] generic-ipi: remove kmalloc()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulmck@linux.vnet.ibm.com
Cc: Oleg Nesterov <oleg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090219024030.GM7011@linux.vnet.ibm.com>
References: <20090217215904.059250145@chello.nl>
	 <20090217220053.500765201@chello.nl>
	 <20090218002823.GA25408@linux.vnet.ibm.com>
	 <20090218161515.GA24895@redhat.com>
	 <20090218194727.GB7011@linux.vnet.ibm.com>
	 <20090218201252.GA5895@redhat.com>
	 <20090219024030.GM7011@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 19 Feb 2009 09:33:29 +0100
Message-Id: <1235032409.4612.0.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-18 at 18:40 -0800, Paul E. McKenney wrote:
> 
> In the meantime, I nominate the following comment at the end of
> csd_lock():
> 
>         /*
>          * prevent CPU from reordering the above assignment to ->flags
>          * with any subsequent assignments to other fields of the
>          * specified call_single_data structure.
>          */
> 
>         smp_mb(); /* See above block comment. */

Done, thanks Paul!

