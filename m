Return-Path: <linux-kernel-owner+w=401wt.eu-S1762492AbYALJe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762492AbYALJe5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 04:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758581AbYALJem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 04:34:42 -0500
Received: from ns2.suse.de ([195.135.220.15]:42176 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756621AbYALJei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 04:34:38 -0500
Date: Sat, 12 Jan 2008 10:34:36 +0100
From: Nick Piggin <npiggin@suse.de>
To: Jes Sorensen <jes@sgi.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Cliff Wickman <cpw@sgi.com>, airlied@linux.ie, benh@kernel.crashing.org,
       michael@ellerman.id.au, jk@ozlabs.org,
       Cedric Le Goater <clg@fr.ibm.com>
Subject: Re: [rfc][patch] reimplement nopfn callers with fault
Message-ID: <20080112093436.GB25048@wotan.suse.de>
References: <20080108113221.GA460@wotan.suse.de> <47877FCA.8050707@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47877FCA.8050707@sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2008 at 03:40:10PM +0100, Jes Sorensen wrote:
> Nick Piggin wrote:
> >Hi guys,
> >
> >I'd like to finally remove nopfn from the tree. So I would really like to 
> >get
> >this patch into -mm soon (or broken out patches into appropriate trees).
> >
> >Anyway, I don't have a good way to compile mspec or cell changes very 
> >easily.
> >Hopefully if there are any silly typos, they will be easier to fix. More 
> >problematic
> >is actually testing the things; I'm not even sure I'm covering all bases 
> >with
> >drm testing.
> >
> >So, if I could trouble you for a quick review and/or test at some time.... 
> >the
> >patch is against latest -mm.
> 
> Nick,
> 
> Is this supposed to apply to the latest Linus tree? I applied it here
> and the mspec driver lights up in beautiful fireworks :-( I'll give the
> -mm tree a try next.

Hi Jes,

(reply to all this time).

It is the BUG_ON(vma->vm_flags & VM_PFNMAP); at the start of __do_fault, by
the looks. That should be simply removed. Sorry about that.

Thanks,
Nick
