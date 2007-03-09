Return-Path: <linux-kernel-owner+w=401wt.eu-S2992971AbXCIFN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992971AbXCIFN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 00:13:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992973AbXCIFN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 00:13:57 -0500
Received: from mail20.syd.optusnet.com.au ([211.29.132.201]:43469 "EHLO
	mail20.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992971AbXCIFN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 00:13:56 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [RSDL-mm 0/6] RSDL cpu scheduler for -mm
Date: Fri, 9 Mar 2007 16:13:18 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, ck@vds.kolivas.org
References: <200703071226.43238.kernel@kolivas.org> <20070307174345.4c398171.akpm@linux-foundation.org> <20070307185430.31fb48b8.akpm@linux-foundation.org>
In-Reply-To: <20070307185430.31fb48b8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703091613.18873.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 March 2007 13:54, Andrew Morton wrote:
> On Wed, 7 Mar 2007 17:43:45 -0800 Andrew Morton <akpm@linux-foundation.org> 
wrote:
> > On Wed, 7 Mar 2007 12:26:42 +1100
> >
> > Con Kolivas <kernel@kolivas.org> wrote:
> > > What follows is the same patch series that constitutes the RDSL
> > > "Rotating Staircase DeadLine" cpu scheduler resynced for
> > > 2.6.21-rc2-mm2.
> >
> > Big oops early in boot on x86_64 SMP, in rq_bitmap_error+0x97/0x9f.
> >
> > I stubbed it out with a `return MAX_RT_PRIO;' (I think) but it then
> > oopsed differently.  Before netconsole had come up, no serial console, no
> > digital camera.
> >
> > There's stuff in http://userweb.kernel.org/~akpm/ck/ - you can probably
> > boot that kernel on your own machine.
> >
> > I need to do rc3-mm1 now.  I might find some time to poke at this
> > further after that, but I have to leave for a week in .jp and it'll be
> > squeezy, sorry.
>
> well it boots os dual pIII and quad powerpc.
>
> The powerpc says
>
> Scheduler bitmap error - bitmap being reconstructed..
>
> during bootup.  But it didn't crash like the Nocona machine.

Any chance I could get the config of this powerpc so I can try building and 
running one on qemu? I can't seem to get this bitmap error on x86*.

Thanks!

-- 
-ck
