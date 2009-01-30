Return-Path: <linux-kernel-owner+w=401wt.eu-S1755255AbZA3QqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbZA3QqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 11:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbZA3QqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 11:46:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751407AbZA3QqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 11:46:02 -0500
Date: Fri, 30 Jan 2009 08:45:01 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Peter Zijlstra <peterz@infradead.org>
cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Maksim Yevmenkin <maksim.yevmenkin@gmail.com>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, will@crowder-design.com,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Fix OOPS in mmap_region() when merging adjacent VM_LOCKED
 file segments
In-Reply-To: <1233304450.4495.147.camel@laptop>
Message-ID: <alpine.LFD.2.00.0901300844020.3150@localhost.localdomain>
References: <bb4a86c70901281151w4300605r3882461cd6e9774a@mail.gmail.com>  <alpine.LFD.2.00.0901281316450.3123@localhost.localdomain>  <1233259410.2315.75.camel@lts-notebook>  <alpine.LFD.2.00.0901291228250.3123@localhost.localdomain> 
 <alpine.LFD.2.00.0901291245170.3054@localhost.localdomain> <1233304450.4495.147.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 30 Jan 2009, Peter Zijlstra wrote:
>
> > +       vma = vma_merge(mm, prev, addr, addr + len, vm_flags, NULL, file, pgoff, NULL);
> > +       if (vma)
> > +               goto out;
> 
> You've made checkpatch unhappy ;-)

Yeah, we need to fix that piece of crud.

checkpatch, that is.

I think "git grep" is more important than the "ooh, I have a tiny d*ck, 
everybody else should have one too" argument against larger terminals.

		Linus
