Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067AbXD0Qg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbXD0Qg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 12:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756073AbXD0Qg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 12:36:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:53589 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756067AbXD0Qg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 12:36:28 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Mel Gorman <mel@skynet.ie>
Subject: Re: [PATCH] Add vDSO for x86-64 with gettimeofday/clock_gettime/getcpu fix
Date: Fri, 27 Apr 2007 18:34:13 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steve Fox <drfickle@us.ibm.com>, Andy Whitcroft <apw@shadowen.org>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org> <20070427085958.GA3645@skynet.ie> <20070427155005.GA20839@skynet.ie>
In-Reply-To: <20070427155005.GA20839@skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704271834.13249.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 April 2007 17:50:06 Mel Gorman wrote:
> On (27/04/07 09:59), Mel Gorman didst pronounce:
> > On (27/04/07 02:39), Andi Kleen didst pronounce:
> > > 
> > > 
> > > > That's vdso.lds.S, not vdso.lds. The VDSO_TEXT_OFFSET is still 0x400.
> > > > This is what I should have posted the last time
> > > > 
> > > > --- build/arch/x86_64/vdso/voffset.h.orig	2007-04-26 08:43:31.523739878 -0700
> > > > +++ build/arch/x86_64/vdso/voffset.h	2007-04-26 08:43:38.839579356 -0700
> > > > @@ -1 +1 @@
> > > > -#define VDSO_TEXT_OFFSET 0x500
> > > > +#define VDSO_TEXT_OFFSET 0x400
> > > 
> > > It's definitely 0x400 here. Is your patch reversed and you want 0x500? 
> > > 
> > 
> > Sorry, that patch is reversed. It's 0x500 it needs to be to work here.
> > 
> 
> What I should have done in the first place..... Sorry for the noise.

I had already fixed it up. 

But now can you test Suresh's latest patch too please?

-Andi
