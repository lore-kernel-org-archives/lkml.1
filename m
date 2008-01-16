Return-Path: <linux-kernel-owner+w=401wt.eu-S1751792AbYAPJDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbYAPJDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 04:03:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628AbYAPJDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 04:03:09 -0500
Received: from cantor.suse.de ([195.135.220.2]:48547 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbYAPJDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 04:03:07 -0500
Date: Wed, 16 Jan 2008 10:03:02 +0100
From: Nick Piggin <npiggin@suse.de>
To: Jes Sorensen <jes@sgi.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Cliff Wickman <cpw@sgi.com>, airlied@linux.ie, benh@kernel.crashing.org,
       michael@ellerman.id.au, jk@ozlabs.org,
       Cedric Le Goater <clg@fr.ibm.com>
Subject: Re: [rfc][patch] reimplement nopfn callers with fault
Message-ID: <20080116090302.GA19315@wotan.suse.de>
References: <20080108113221.GA460@wotan.suse.de> <47877FCA.8050707@sgi.com> <20080112093436.GB25048@wotan.suse.de> <478B2806.3000300@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478B2806.3000300@sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 10:14:46AM +0100, Jes Sorensen wrote:
> Nick Piggin wrote:
> >On Fri, Jan 11, 2008 at 03:40:10PM +0100, Jes Sorensen wrote:
> >>Nick,
> >>
> >>Is this supposed to apply to the latest Linus tree? I applied it here
> >>and the mspec driver lights up in beautiful fireworks :-( I'll give the
> >>-mm tree a try next.
> >
> >Hi Jes,
> >
> >(reply to all this time).
> >
> >It is the BUG_ON(vma->vm_flags & VM_PFNMAP); at the start of __do_fault, by
> >the looks. That should be simply removed. Sorry about that.
> 
> Hi Nick,
> 
> Ok, I pulled that line and now mspec is working as expected for me.
> I'll throw in an ACK for your patch then.
> 
> Acked-by: Jes Sorensen <jes@sgi.com>

Thanks very much for testing that. Given that the concept seems to be
sound, I'll send the patch to -mm.
