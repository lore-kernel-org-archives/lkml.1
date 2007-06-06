Return-Path: <linux-kernel-owner+w=401wt.eu-S932879AbXFFOkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932879AbXFFOkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 10:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765112AbXFFOkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 10:40:15 -0400
Received: from colo.lackof.org ([198.49.126.79]:42366 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762627AbXFFOkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 10:40:12 -0400
Date: Wed, 6 Jun 2007 08:40:03 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
       linux-mm@kvack.org, Ollie Wild <aaw@google.com>,
       Ingo Molnar <mingo@elte.hu>, parisc-linux@lists.parisc-linux.org
Subject: Re: [parisc-linux] Re: [PATCH 4/4] mm: variable length argument
	support
Message-ID: <20070606144003.GD9722@colo.lackof.org>
References: <20070605150523.786600000@chello.nl> <20070605151203.790585000@chello.nl> <20070606013658.20bcbe2f.akpm@linux-foundation.org> <1181120061.7348.177.camel@twins> <20070606020651.19a89dca.akpm@linux-foundation.org> <1181121129.7348.181.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181121129.7348.181.camel@twins>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.15+20070515 (2007-05-02)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 11:12:09AM +0200, Peter Zijlstra wrote:
...
> > I think the same problem will happen on NOMMU && STACK_GROWS_UP.  There are
> > several new references to bprm->vma in there, not all inside CONFIG_MMU.
> 
> Right, which archs have that combo? I'll go gather cross compilers.

parisc only supports with MMU. I don't know who elses uses STACK_GROWS_UP.

hth,
grant

> 
> Perhaps I'd better create a flush_arg_page() function and stick that in
> the mmu/nommu section somewhere earlier on in that file. Patch in a few.
> 
> A related question; does anybody know of a no-MMU arch that uses
> fs/compat.c ? If there is such a beast, that would need some work.
> 
> _______________________________________________
> parisc-linux mailing list
> parisc-linux@lists.parisc-linux.org
> http://lists.parisc-linux.org/mailman/listinfo/parisc-linux
