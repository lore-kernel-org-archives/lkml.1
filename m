Return-Path: <linux-kernel-owner+w=401wt.eu-S1758125AbXGaTLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125AbXGaTLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 15:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbXGaTLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 15:11:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54044 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbXGaTLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 15:11:41 -0400
Date: Wed, 1 Aug 2007 00:54:03 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] Introduce U16_MAX and U32_MAX
In-Reply-To: <20070731115729.64c875d4.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0708010042070.28746@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0707312153500.28746@enigma.security.iitk.ac.in>
 <20070731115729.64c875d4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 31 Jul 2007, Andrew Morton wrote:

> On Tue, 31 Jul 2007 21:56:12 +0530 (IST)
> Satyam Sharma <satyam@infradead.org> wrote:
> 
> > --- a/include/linux/kernel.h
> > +++ b/include/linux/kernel.h
> > @@ -30,6 +30,9 @@ extern const char linux_proc_banner[];
> >  #define LLONG_MIN	(-LLONG_MAX - 1)
> >  #define ULLONG_MAX	(~0ULL)
> >  
> > +#define U16_MAX		((u16) ~0U)
> > +#define U32_MAX		((u32) ~0U)
> > +
> 
> hm, I'd have thought that there's a risk of gcc warnings here, forcing
> 0xffffffff into a u16, but apparently not.
> 
> Still, I think it'd be tidier here to tell the truth and use plain
> old 0xffff and 0xffffffff?

Hmm, that does make sense, actually -- in fact that's the only _really_
correct way to define u32_max / u16_max, I'd say. I probably got confused
seeing those bad examples in reiserfs and tcp_illinois ;-)

Thanks.
