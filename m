Return-Path: <linux-kernel-owner+w=401wt.eu-S1751639AbXCHEPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639AbXCHEPP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 23:15:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbXCHEPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 23:15:15 -0500
Received: from smtp.osdl.org ([65.172.181.24]:47533 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616AbXCHEPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 23:15:13 -0500
Date: Wed, 7 Mar 2007 20:15:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       ck@vds.kolivas.org
Subject: Re: [PATCH] [RSDL-mm 0/6] RSDL cpu scheduler for -mm
Message-Id: <20070307201502.4e93c5d5.akpm@linux-foundation.org>
In-Reply-To: <20070307185430.31fb48b8.akpm@linux-foundation.org>
References: <200703071226.43238.kernel@kolivas.org>
	<20070307174345.4c398171.akpm@linux-foundation.org>
	<20070307185430.31fb48b8.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007 18:54:30 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 7 Mar 2007 17:43:45 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Wed, 7 Mar 2007 12:26:42 +1100
> > Con Kolivas <kernel@kolivas.org> wrote:
> > 
> > > What follows is the same patch series that constitutes the RDSL "Rotating 
> > > Staircase DeadLine" cpu scheduler resynced for 2.6.21-rc2-mm2.
> > 
> > Big oops early in boot on x86_64 SMP, in rq_bitmap_error+0x97/0x9f.
> > 
> > I stubbed it out with a `return MAX_RT_PRIO;' (I think) but it then oopsed
> > differently.  Before netconsole had come up, no serial console, no digital
> > camera.
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

It also boots OK on a very similar but somewhat older Nocona machine.  Perhaps
due to config changes:  http://userweb.kernel.org/~akpm/ck/config-ok.txt

