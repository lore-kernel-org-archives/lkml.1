Return-Path: <linux-kernel-owner+w=401wt.eu-S1762517AbXGSVbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762517AbXGSVbM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 17:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760857AbXGSVay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 17:30:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39128 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760117AbXGSVav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 17:30:51 -0400
Date: Thu, 19 Jul 2007 14:30:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: Powerpc - Include pagemap.h in asm/powerpc/tlb.h
Message-Id: <20070719143020.5e0b7474.akpm@linux-foundation.org>
In-Reply-To: <E7820A72-36A3-4B4D-A497-974409D3EBDE@kernel.crashing.org>
References: <20070714012033.GC31649@Krystal>
	<20070718223034.7388e59f.akpm@linux-foundation.org>
	<D9805F9D-04B0-4422-81F1-958B15482A93@kernel.crashing.org>
	<20070719131348.170443bb.akpm@linux-foundation.org>
	<E7820A72-36A3-4B4D-A497-974409D3EBDE@kernel.crashing.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007 16:04:38 -0500
Kumar Gala <galak@kernel.crashing.org> wrote:

> >> Andrew,
> >>
> >> Are you sending this to linus directly or should this go via paul and
> >> me?
> >>
> >
> > I queued it up for Paul.  I can send it over to Linus today if we  
> > have a
> > reason for that.  It's just that I dont understand the patch: does  
> > it fix
> > -mm-only breakage?  Does it fix something which already got fixed,  
> > or what?
> 
> I'm seeing the same breakage in my tree.

Oh, OK.  Let's just merge it.

> > One might think "gee, it's trivial, just slam it in", but these nested
> > includes are often not-trivial and something else can explode as a  
> > result.
> 
> I'll do a git-bisect and see if I can find the patch that causes this  
> breakage so we know what's going on.

eh, don't bother.
